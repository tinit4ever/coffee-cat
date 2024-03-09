package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.entity_models.Manager;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.request_models.LoginRequest;
import com.swd.ccp.models.request_models.RegisterRequest;
import com.swd.ccp.models.response_models.AccountResponse;
import com.swd.ccp.models.response_models.CheckMailExistedResponse;
import com.swd.ccp.models.response_models.LoginResponse;
import com.swd.ccp.models.response_models.RegisterResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AuthenticationService;
import com.swd.ccp.services.JWTService;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthenticationServiceImpl implements AuthenticationService {

    private final JWTService jwtService;

    private final AccountStatusRepo accountStatusRepo;

    private final AccountRepo accountRepo;

    private final CustomerRepo customerRepo;

    private final TokenRepo tokenRepo;

    private final PasswordEncoder passwordEncoder;

    private final ManagerRepo managerRepo;

    @Override
    public RegisterResponse register(RegisterRequest request) {
        if (isStringValid(request.getEmail()) && isStringValid(request.getPassword())) {
                Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);
                Customer customer;
                Token accessToken;
                Token refreshToken;

                if (account == null) {
                    account = accountRepo.save(
                            Account.builder()
                                    .email(request.getEmail())
                                    .name(request.getName())
                                    .password(passwordEncoder.encode(request.getPassword()))
                                    .phone(isStringValid(request.getPhone()) ? request.getPhone() : null)
                                    .status(accountStatusRepo.findById(1).orElse(null))
                                    .role(Role.CUSTOMER)
                                    .build()
                    );

                    accessToken = tokenRepo.save(
                            Token.builder()
                                    .token(jwtService.generateToken(account))
                                    .type("access")
                                    .status(1)
                                    .build()
                    );

                    refreshToken = tokenRepo.save(
                            Token.builder()
                                    .token(jwtService.generateRefreshToken(account))
                                    .type("refresh")
                                    .status(1)
                                    .build()
                    );

                    customer = customerRepo.save(
                            Customer.builder()
                                    .account(account)
                                    .gender(isStringValid(request.getGender()) ? request.getGender() : null)
                                    .dob(request.getDob() != null ? request.getDob() : null)
                                    .build()
                    );

                    return RegisterResponse.builder()
                            .message("Register successfully")
                            .status(true)
                            .accessToken(accessToken.getToken())
                            .refreshToken(refreshToken.getToken())
                            .accountResponse(
                                    AccountResponse.builder()
                                            .id(customer.getAccount().getId())
                                            .email(customer.getAccount().getEmail())
                                            .name(customer.getAccount().getUsername())
                                            .phone(customer.getAccount().getPhone())
                                            .dob(customer.getDob())
                                            .gender(customer.getGender())
                                            .status(customer.getAccount().getStatus().getStatus())
                                            .role(customer.getAccount().getRole().name())
                                            .build()
                            )
                            .build();
                }
                return RegisterResponse.builder()
                        .message("Account is already existed")
                        .status(false)
                        .accessToken(null)
                        .refreshToken(null)
                        .accountResponse(null)
                        .build();
            }
            return RegisterResponse.builder()
                    .message("Unmatched password and confirmed password")
                    .status(false)
                    .accessToken(null)
                    .refreshToken(null)
                    .accountResponse(null)
                    .build();
        }

    @Override
    public CheckMailExistedResponse checkUserIsExisted(String email) {
        if(accountRepo.findByEmail(email).orElse(null) != null){
            return CheckMailExistedResponse.builder()
                    .status(false)
                    .message("User is existed")
                    .build();
        }
        return CheckMailExistedResponse.builder()
                .status(true)
                .message("")
                .build();
    }


    @Override
    public LoginResponse login(LoginRequest request) {
        if (isStringValid(request.getEmail() ) && isStringValid(request.getPassword())) {
            Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);

            if (account != null
                    && passwordEncoder.matches(request.getPassword(), account.getPassword())
            ) {
                List<Token> tokenList = refreshToken(account);
                if (account.getStatus().getStatus().equals("active") && tokenList.size() == 2) {
                    for(Token token: tokenList){
                        if (!tokenRepo.existsByToken(token.getToken())) {
                            tokenRepo.save(token);
                        }
                    }

                    if(account.getRole().equals(Role.STAFF) || account.getRole().equals(Role.OWNER)){
                        return loginStaffAndOwnerResponse(tokenList, account);
                    }

                    return loginCustomerResponse(tokenList, account);
                }
                return loginAccountBannedResponse();
            }
            return loginNameOrPassIncorrectResponse();
        }
        return loginNameOrPassIncorrectFormatResponse();
    }

    private LoginResponse loginCustomerResponse(List<Token> tokenList, Account account){
        return LoginResponse
                .builder()
                .message("Login successfully")
                .accessToken(tokenList.get(0).getToken())
                .refreshToken(tokenList.get(1).getToken())
                .status(true)
                .accountResponse(
                        LoginResponse.AccountResponse
                                .builder()
                                .id(1)
                                .email(account.getEmail())
                                .name(account.getName())
                                .phone(account.getPhone())
                                .gender(checkIfAccountIsCustomer(account) != null ? checkIfAccountIsCustomer(account).getGender() : null)
                                .dob(checkIfAccountIsCustomer(account) != null ? checkIfAccountIsCustomer(account).getDob() : null)
                                .status(account.getStatus().getStatus())
                                .shopId(null)
                                .shopName(null)
                                .role(account.getRole().name())
                                .build()
                )
                .build();
    }

    private LoginResponse loginStaffAndOwnerResponse(List<Token> tokenList, Account account){
        Manager manager = managerRepo.findByAccount(account).orElse(null);
        assert manager != null;

        return LoginResponse
                .builder()
                .message("Login successfully")
                .accessToken(tokenList.get(0).getToken())
                .refreshToken(tokenList.get(1).getToken())
                .status(true)
                .accountResponse(
                        LoginResponse.AccountResponse
                                .builder()
                                .id(1)
                                .email(account.getEmail())
                                .name(account.getName())
                                .phone(account.getPhone())
                                .gender(checkIfAccountIsCustomer(account) != null ? checkIfAccountIsCustomer(account).getGender() : null)
                                .dob(checkIfAccountIsCustomer(account) != null ? checkIfAccountIsCustomer(account).getDob() : null)
                                .status(account.getStatus().getStatus())
                                .shopId(manager.getShop().getId())
                                .shopName(manager.getShop().getName())
                                .role(account.getRole().name())
                                .build()
                )
                .build();
    }

    private LoginResponse loginAccountBannedResponse(){
        return LoginResponse.builder()
                .message("Account has been banned")
                .accessToken(null)
                .refreshToken(null)
                .status(false)
                .accountResponse(null)
                .build();
    }

    private LoginResponse loginNameOrPassIncorrectResponse(){
        return LoginResponse.builder()
                .message("Username or password is incorrect")
                .accessToken(null)
                .refreshToken(null)
                .status(false)
                .accountResponse(null)
                .build();
    }

    private LoginResponse loginNameOrPassIncorrectFormatResponse(){
        return LoginResponse.builder()
                .message("Username or password is wrong format")
                .accessToken(null)
                .refreshToken(null)
                .status(false)
                .accountResponse(null)
                .build();
    }



    private Customer checkIfAccountIsCustomer(Account account){
        return customerRepo.findByAccount_Email(account.getEmail()).orElse(null);
    }

    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }

    private Token getAccessToken(Integer accountId) {
        return tokenRepo.findByAccount_IdAndStatusAndType(accountId, 1, "access").orElse(null);
    }

    private Token getRefreshToken(Integer accountId) {
        return tokenRepo.findByAccount_IdAndStatusAndType(accountId, 1, "refresh").orElse(null);
    }

    private List<Token> refreshToken(@NonNull Account account) {
        Token access = getAccessToken(account.getId());
        Token refresh = getRefreshToken(account.getId());
        List<Token> tokenList = new ArrayList<>();
        if (access != null && refresh == null) {
            Token newRefreshToken = Token.builder()
                    .account(account)
                    .token(jwtService.generateRefreshToken(account))
                    .type("refresh")
                    .status(1)
                    .build();
            tokenList.add(access);
            tokenList.add(newRefreshToken);
        }
        if (access != null && refresh != null) {
            tokenList.add(access);
            tokenList.add(refresh);
        }
        if (access == null && refresh != null) {
            Token newAccessToken = Token.builder()
                    .account(account)
                    .token(jwtService.generateToken(account))
                    .type("access")
                    .status(1)
                    .build();
            tokenList.add(newAccessToken);
            tokenList.add(refresh);
        }
        if (access == null && refresh == null) {
            tokenList.add(Token.builder()
                    .account(account)
                    .token(jwtService.generateToken(account))
                    .type("access")
                    .status(1)
                    .build());

            tokenList.add(Token.builder()
                    .account(account)
                    .token(jwtService.generateRefreshToken(account))
                    .type("refresh")
                    .status(1)
                    .build());
        }
        return tokenList;
    }
}
