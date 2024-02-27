package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.UpdateProfileRequest;
import com.swd.ccp.models.response_models.BookingHistoryResponse;
import com.swd.ccp.models.response_models.CustomerProfile;
import com.swd.ccp.models.response_models.UpdateProfileResponse;
import com.swd.ccp.services.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/customer")
public class CustomerController {
    private final CustomerService customerService;
    @GetMapping("/profile")
    @PreAuthorize("hasAuthority('customer:read')")
    public ResponseEntity<CustomerProfile> getCustomerProfile(@RequestHeader("Authorization") String token) {
        try {
            CustomerProfile profile = customerService.getCustomerProfile(token);
            return ResponseEntity.ok(profile);
        } catch (NotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
    @PostMapping("/update/profile")
    @PreAuthorize("hasAuthority('customer:update')")
    public ResponseEntity<String> updateCustomerProfile(@RequestHeader("Authorization") String token, @RequestBody UpdateProfileRequest profile) {
        try {
            customerService.updateProfile(token, profile);
            return ResponseEntity.ok("Profile updated successfully");
        } catch (NotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Customer profile not found");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid request");
        }
    }

    @GetMapping("/history")
    @PreAuthorize("hasAuthority('customer:read')")
    public ResponseEntity<BookingHistoryResponse> getBookingHistory(){
        return ResponseEntity.ok().body(customerService.getBookingHistory());
    }
}
