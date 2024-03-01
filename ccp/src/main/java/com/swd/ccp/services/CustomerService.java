package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.request_models.UpdateProfileRequest;
import com.swd.ccp.models.response_models.BookingHistoryResponse;
import com.swd.ccp.models.response_models.CustomerProfile;
import com.swd.ccp.models.response_models.UpdateProfileResponse;
import org.springframework.web.bind.annotation.RequestHeader;

public interface CustomerService {
    CustomerProfile getCustomerProfile(@RequestHeader("Authorization") String token);
    UpdateProfileResponse updateProfile(String token, UpdateProfileRequest updateRequest);
    BookingHistoryResponse getBookingHistory();
    Customer takeCustomerFromAccount(Account account);
}
