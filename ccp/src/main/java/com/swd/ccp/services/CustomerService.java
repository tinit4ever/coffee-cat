package com.swd.ccp.services;

import com.swd.ccp.models.request_models.UpdateProfileRequest;
import com.swd.ccp.models.response_models.CustomerProfile;
import com.swd.ccp.models.response_models.UpdateProfileResponse;
import org.springframework.web.bind.annotation.RequestHeader;

public interface CustomerService {
    CustomerProfile getCustomerProfile(@RequestHeader("Authorization") String token);
    UpdateProfileResponse updateProfile(String token, UpdateProfileRequest updateRequest);
}
