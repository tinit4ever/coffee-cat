package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.UpdateProfileRequest;
import com.swd.ccp.models.response_models.CustomerProfile;
import com.swd.ccp.models.response_models.UpdateProfileResponse;
import com.swd.ccp.repositories.AccountRepo;
import com.swd.ccp.repositories.CustomerRepo;
import com.swd.ccp.services.CustomerService;
import com.swd.ccp.services.JWTService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerServiceIml implements CustomerService {
    private final AccountRepo accountRepo;
    private final CustomerRepo customerRepo;
    private final JWTService jwtService;
    private static final String ACTIVE = "Active";


    @Override
    public CustomerProfile getCustomerProfile(String token) {
        String email = jwtService.extractEmail(token.substring(7)); // Loại bỏ tiền tố "Bearer "

        if (email != null) {
            Optional<Customer> optionalCustomer = customerRepo.findByAccount_Email(email);
            if (optionalCustomer.isPresent()) {
                Customer customer = optionalCustomer.get();
                CustomerProfile profile = new CustomerProfile();
                profile.setUsername(customer.getAccount().getUsername());
                profile.setEmail(customer.getAccount().getEmail());
                profile.setPhone(customer.getPhone());
                profile.setGender(customer.getGender());
                profile.setDob(customer.getDob());
                return profile;
            } else {
                throw new NotFoundException("Customer profile not found.");
            }
        } else {
            throw new IllegalArgumentException("Invalid token");
        }
    }


    @Override
    public UpdateProfileResponse updateProfile(String token, UpdateProfileRequest updateRequest) {
        String email = jwtService.extractEmail(token.substring(7));
        Optional<Customer> optionalProfile = customerRepo.findByAccount_Email(email);
        if (optionalProfile.isPresent()) {
            Customer profile = optionalProfile.get();
            if (updateRequest.getUsername() != null) {
                profile.getAccount().setName(updateRequest.getUsername());
            }
            if (updateRequest.getDob() != null) {
                profile.setDob(updateRequest.getDob());
            }
            if (updateRequest.getGender() != null) {
                profile.setGender(updateRequest.getGender());
            }
            customerRepo.save(profile);

            UpdateProfileResponse response = new UpdateProfileResponse();
            response.setMessage("Profile information updated successfully.");
            response.setSuccess(true);

            return response;
        } else {
            throw new NotFoundException("Customer is not found.");
        }
    }
}
