package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.services.ShopOwnerService;
import com.swd.ccp.services.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/owner")
public class ShopOwnerController {


    private final ShopOwnerService shopOwnerService;
    @PostMapping("/staff/list")
    @PreAuthorize("hasAuthority('owner:read')")
    public ResponseEntity<StaffListResponse> GetStaffList(@RequestBody SortRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.getStaffList(request));
    }

    @PostMapping("/staff/create")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateStaffResponse> createStaff(@RequestBody StaffRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.createStaff(request));
    }
    @PostMapping("/staff/update")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<UpdateStaffResponse> updateStaff(@PathVariable Integer staffId,
                                                           @RequestBody StaffRequest updateRequest) {
        try {
            UpdateStaffResponse response = shopOwnerService.updateStaff(staffId, updateRequest);
            return ResponseEntity.ok().body(response);
        } catch (NotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    @PostMapping("/staff/inactive")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> inactiveStaff(@PathVariable Integer staffId) {
        int result = shopOwnerService.inactiveStaff(staffId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + staffId + " has been successfully inactivated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @PostMapping("/staff/active")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> activeStaff(@PathVariable Integer staffId) {
        int result = shopOwnerService.activeStaff(staffId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + staffId + " has been successfully activated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
