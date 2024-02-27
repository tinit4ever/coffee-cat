package com.swd.ccp.services_implementors;

import com.swd.ccp.models.response_models.RefreshResponse;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final AccountService accountService;
    @Override
    public RefreshResponse refresh() {
        return RefreshResponse.builder().accessToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId())).build();
    }
}
