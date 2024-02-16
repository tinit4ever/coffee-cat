package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.request_models.LoginRequest;
import com.swd.ccp.models.request_models.RegisterRequest;
import com.swd.ccp.models.response_models.AccountResponse;
import com.swd.ccp.models.response_models.LoginResponse;
import com.swd.ccp.models.response_models.RegisterResponse;
import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.repositories.AccountRepo;
import com.swd.ccp.repositories.AccountStatusRepo;
import com.swd.ccp.repositories.CustomerRepo;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.AuthenticationService;
import com.swd.ccp.services.JWTService;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
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

    @Override
    public RegisterResponse register(RegisterRequest request) {
        if (isStringValid(request.getEmail()) &&
                isStringValid(request.getPassword())) {
                Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);
                Customer customer;
                Token accessToken;
                Token refreshToken;

                if (account == null) {
                    account = accountRepo.save(
                            Account.builder()
                                    .email(request.getEmail())
                                    .name(request.getName())
                                    .password(request.getPassword())
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
                                    .phone(isStringValid(request.getPhone()) ? request.getPhone() : null)
                                    .gender(isStringValid(request.getGender()) ? request.getGender() : null)
                                    .dob(request.getDob() != null ? request.getDob() : null)
                                    .build()
                    );

                    return RegisterResponse.builder()
                            .message("Register successfully")
                            .status(true)
                            .access_token(accessToken.getToken())
                            .refresh_token(refreshToken.getToken())
                            .accountResponse(
                                    AccountResponse.builder()
                                            .id(customer.getAccount().getId())
                                            .email(customer.getAccount().getEmail())
                                            .username(customer.getAccount().getUsername())
                                            .phone(customer.getPhone())
                                            .gender(customer.getGender())
                                            .dob(customer.getDob())
                                            .status(customer.getAccount().getStatus().getStatus())
                                            .role(customer.getAccount().getRole().name())
                                            .build()
                            )
                            .build();
                }
                return RegisterResponse.builder()
                        .message("Register fail: account is already existed")
                        .status(false)
                        .access_token(null)
                        .refresh_token(null)
                        .accountResponse(null)
                        .build();
            }
            return RegisterResponse.builder()
                    .message("Register fail: unmatched password")
                    .status(false)
                    .access_token(null)
                    .refresh_token(null)
                    .accountResponse(null)
                    .build();
        }


    @Override
    public LoginResponse login(LoginRequest request) {
        if (isStringValid(request.getEmail()) && isStringValid(request.getPassword())) {
            Account account = accountRepo.findByEmail(request.getEmail()).orElse(null);

            if (account != null) {
                List<Token> tokenList = refreshToken(account);
                if (account.getStatus().getId() == 1) {

                    tokenList.forEach(token -> {
                        Token t = tokenRepo.findByToken(token.getToken()).orElse(null);
                        if (t == null) {
                            tokenRepo.save(token);
                        }
                    });

                    return LoginResponse
                            .builder()
                            .message("Login successfully")
                            .access_token(tokenList.get(0).getToken())
                            .refresh_token(tokenList.get(1).getToken())
                            .status(true)
                            .accountResponse(
                                    AccountResponse
                                            .builder()
                                            .id(1)
                                            .email(account.getEmail())
                                            .username(account.getName())
                                            .status(account.getStatus().getStatus())
                                            .role(account.getRole().name())
                                            .build()
                            )
                            .build();
                }
                return LoginResponse.builder()
                        .message("Login fail: account has been banned")
                        .access_token(null)
                        .refresh_token(null)
                        .status(false)
                        .accountResponse(null)
                        .build();
            }
            return LoginResponse.builder()
                    .message("Login fail: account does not existed")
                    .access_token(null)
                    .refresh_token(null)
                    .status(false)
                    .accountResponse(null)
                    .build();
        }
        return LoginResponse.builder()
                .message("Login fail: Username or password incorrect")
                .access_token(null)
                .refresh_token(null)
                .status(false)
                .accountResponse(null)
                .build();
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
