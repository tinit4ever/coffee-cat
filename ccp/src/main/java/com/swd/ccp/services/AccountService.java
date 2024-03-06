package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.request_models.ChangeAccountStatusRequest;
import com.swd.ccp.models.request_models.CreateShopRequest;
import com.swd.ccp.models.response_models.ChangeAccountStatusResponse;
import com.swd.ccp.models.response_models.GetAllAccountAdminResponse;
import com.swd.ccp.models.response_models.LogoutResponse;
import com.swd.ccp.models.response_models.RefreshResponse;

public interface AccountService {

    String getAccessToken(Integer accountID);
    String getRefreshToken(Integer accountID);

    Account getCurrentLoggedUser();

    LogoutResponse logout();

    Account createOwnerAccount(CreateShopRequest request, String randomPass);

    public String generateRandomPassword(int length);

    RefreshResponse refresh();

    GetAllAccountAdminResponse getAllAccount();

    ChangeAccountStatusResponse changeAccountStatus(ChangeAccountStatusRequest request, String type);
}
