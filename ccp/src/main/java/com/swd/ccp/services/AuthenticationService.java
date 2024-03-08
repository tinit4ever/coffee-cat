package com.swd.ccp.services;

import com.swd.ccp.models.request_models.LoginRequest;
import com.swd.ccp.models.request_models.RegisterRequest;
import com.swd.ccp.models.response_models.CheckMailExistedResponse;
import com.swd.ccp.models.response_models.LoginResponse;
import com.swd.ccp.models.response_models.LogoutResponse;
import com.swd.ccp.models.response_models.RegisterResponse;

public interface AuthenticationService {

    RegisterResponse register(RegisterRequest request);

    Object login(LoginRequest request);

    CheckMailExistedResponse checkUserIsExisted(String email);
}
