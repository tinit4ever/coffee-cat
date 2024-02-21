package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.response_models.LogoutResponse;

public interface AccountService {

    String getAccessToken(Integer accountID);
    String getRefreshToken(Integer accountID);

    Account getCurrentLoggedUser();

    LogoutResponse logout();
}
