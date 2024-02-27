package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.models.response_models.RefreshResponse;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.JWTService;
import com.swd.ccp.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final AccountService accountService;

    private final TokenRepo tokenRepo;

    private final JWTService jwtService;
    @Override
    public RefreshResponse refresh() {
        Account account = accountService.getCurrentLoggedUser();
        assert account != null;
        Token current = tokenRepo.findByToken(accountService.getAccessToken(account.getId())).orElse(null);
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
}
