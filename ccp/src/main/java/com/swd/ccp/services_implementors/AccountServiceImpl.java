package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.request_models.ChangeAccountStatusRequest;
import com.swd.ccp.models.request_models.CreateShopRequest;
import com.swd.ccp.models.response_models.ChangeAccountStatusResponse;
import com.swd.ccp.models.response_models.GetAllAccountAdminResponse;
import com.swd.ccp.models.response_models.LogoutResponse;
import com.swd.ccp.models.response_models.RefreshResponse;
import com.swd.ccp.repositories.AccountRepo;
import com.swd.ccp.repositories.AccountStatusRepo;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private final AccountRepo accountRepo;
    private final AccountStatusRepo accountStatusRepo;
    private final TokenRepo tokenRepo;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jwtService;
    @Override
    public String getAccessToken(Integer accountID) {
        Account account = accountRepo.findById(accountID).orElse(null);
        if(account != null){
            Token accessToken = tokenRepo.findByAccount_IdAndStatusAndType(accountID, 1, "access").orElse(null);
            return accessToken != null ? accessToken.getToken() : null;
        }
        return null;
    }

    @Override
    public String getRefreshToken(Integer accountID) {
        Account account = accountRepo.findById(accountID).orElse(null);
        if(account != null){
            Token refreshToken = tokenRepo.findByAccount_IdAndStatusAndType(accountID, 1, "refresh").orElse(null);
            return refreshToken != null ? refreshToken.getToken() : null;
        }
        return null;
    }

    @Override
    public Account getCurrentLoggedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return accountRepo.findByEmail(authentication.getName()).orElse(null);
    }

    @Override
    public LogoutResponse logout() {
        Account account = getCurrentLoggedUser();
        if(account != null){
            Token accessToken = tokenRepo.findByAccount_IdAndStatusAndType(account.getId(), 1, "access").orElse(null);
            Token refreshToken = tokenRepo.findByAccount_IdAndStatusAndType(account.getId(), 1, "refresh").orElse(null);
            if(accessToken != null){
                accessToken.setStatus(0);
                tokenRepo.save(accessToken);
            }
            if(refreshToken != null){
                refreshToken.setStatus(0);
                tokenRepo.save(refreshToken);
            }
            return LogoutResponse.builder().status(true).message("Logout successfully").build();
        }
        return LogoutResponse.builder().status(false).message("Ooh! Something happen").build();
    }

    @Override
    public Account createOwnerAccount(CreateShopRequest request, String randomPass) {
        AccountStatus accountStatus = accountStatusRepo.findByStatus("active");
        Account account = accountRepo.findByEmail(request.getShopEmail()).orElse(null);
        if(account == null){
            return accountRepo.save(
                    Account.builder()
                            .email(request.getShopEmail() + "@ccp.so.com")
                            .name(request.getName())
                            .password(passwordEncoder.encode(randomPass))
                            .phone(request.getPhone())
                            .status(accountStatus)
                            .role(Role.OWNER)
                            .build()
            );
        }
        return null;
    }

    @Override
    public String generateRandomPassword(int length) {
        String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(CHARACTERS.length());
            password.append(CHARACTERS.charAt(randomIndex));
        }
        return password.toString();
    }

    @Override
    public RefreshResponse refresh() {
        Account account = getCurrentLoggedUser();
        assert account != null;
        Token current = tokenRepo.findByToken(getAccessToken(account.getId())).orElse(null);
        assert current != null;
        current.setStatus(0);
        tokenRepo.save(current);
        Token newToken = tokenRepo.save(
                Token.builder()
                        .account(account)
                        .status(1)
                        .token(jwtService.generateToken(account))
                        .type("access")
                        .build()
        );

        return RefreshResponse.builder().accessToken(newToken.getToken()).build();
    }

    @Override
    public GetAllAccountAdminResponse getAllAccount() {
        List<Account> accounts = accountRepo.findAll();
        List<GetAllAccountAdminResponse.AccountResponse> accountList = new ArrayList<>();

        List<GetAllAccountAdminResponse.AccountResponse> ownerList = new ArrayList<>();
        List<GetAllAccountAdminResponse.AccountResponse> staffList = new ArrayList<>();
        List<GetAllAccountAdminResponse.AccountResponse> customerList = new ArrayList<>();
        for(Account account: accounts){
            if(account.getRole().equals(Role.OWNER)){
                ownerList.add(
                        GetAllAccountAdminResponse.AccountResponse.builder()
                                .id(account.getId())
                                .email(account.getEmail())
                                .name(account.getName())
                                .phone(account.getPhone())
                                .status(account.getStatus().getStatus())
                                .role(account.getRole().name())
                                .build()
                );
            }

            if(account.getRole().equals(Role.STAFF)){
                staffList.add(
                        GetAllAccountAdminResponse.AccountResponse.builder()
                                .id(account.getId())
                                .email(account.getEmail())
                                .name(account.getName())
                                .phone(account.getPhone())
                                .status(account.getStatus().getStatus())
                                .role(account.getRole().name())
                                .build()
                );
            }

            if(account.getRole().equals(Role.CUSTOMER)){
                customerList.add(
                        GetAllAccountAdminResponse.AccountResponse.builder()
                                .id(account.getId())
                                .email(account.getEmail())
                                .name(account.getName())
                                .phone(account.getPhone())
                                .status(account.getStatus().getStatus())
                                .role(account.getRole().name())
                                .build()
                );
            }
        }

        accountList.addAll(ownerList);
        accountList.addAll(staffList);
        accountList.addAll(customerList);
        return GetAllAccountAdminResponse.builder()
                .accountResponseList(accountList)
                .build();
    }

    @Override
    public ChangeAccountStatusResponse changeAccountStatus(ChangeAccountStatusRequest request, String type) {
        if (type.equals("ban")) {
            return banAccount(request);
        }
        return unbanAccount(request);
    }

    private ChangeAccountStatusResponse banAccount(ChangeAccountStatusRequest request){
        Account account = accountRepo.findById(request.getAccountId()).orElse(null);
        AccountStatus inactive = accountStatusRepo.findByStatus("inactive");
        if(account != null){
            if(!account.getStatus().equals(inactive)){
                account.setStatus(inactive);
                accountRepo.save(account);
                return ChangeAccountStatusResponse.builder()
                        .status(true)
                        .message("Account with id " + request.getAccountId() + " is banned")
                        .build();
            }
            return ChangeAccountStatusResponse.builder()
                    .status(false)
                    .message("Account with id " + request.getAccountId() + " is already been banned")
                    .build();
        }
        return ChangeAccountStatusResponse.builder()
                .status(false)
                .message("Account with id " + request.getAccountId() + " is not existed")
                .build();
    }

    private ChangeAccountStatusResponse unbanAccount(ChangeAccountStatusRequest request){
        Account account = accountRepo.findById(request.getAccountId()).orElse(null);
        AccountStatus active = accountStatusRepo.findByStatus("active");
        if(account != null){
            if(!account.getStatus().equals(active)){
                account.setStatus(active);
                accountRepo.save(account);
                return ChangeAccountStatusResponse.builder()
                        .status(true)
                        .message("Account with id " + request.getAccountId() + " is active")
                        .build();
            }
            return ChangeAccountStatusResponse.builder()
                    .status(false)
                    .message("Account with id " + request.getAccountId() + " is already active")
                    .build();
        }
        return ChangeAccountStatusResponse.builder()
                .status(false)
                .message("Account with id " + request.getAccountId() + " is not existed")
                .build();
    }
}
