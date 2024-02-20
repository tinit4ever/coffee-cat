package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Account;

public interface AccountService {

    String getAccessToken(Integer accountID);
    String getRefreshToken(Integer accountID);

    Account getCurrentLoggedUser();
}
