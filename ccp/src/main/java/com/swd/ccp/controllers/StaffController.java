package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;
import com.swd.ccp.services.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequestMapping("/staff")
@RequiredArgsConstructor
public class StaffController {
    private final StaffService staffService;

    @GetMapping("/list-staff")
    @PreAuthorize("hasAuthority('owner:read')")
    public Page<StaffResponse> getStaffList(@RequestBody PaginationRequest pageRequest) {
        Page<StaffResponse> page = staffService.getStaffList(pageRequest);
        LOGGER.info("get list successfully");
        return page;
    }

    @PostMapping("/createStaff")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateStaffResponse> createStaff(@RequestBody StaffRequest request) {
        CreateStaffResponse response = staffService.createStaff(request);
        if (response.isStatus()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }
    @PostMapping("updateStaff/{staffId}")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<UpdateStaffResponse> updateStaff(@PathVariable Long staffId,
                                                           @RequestBody StaffRequest updateRequest) {
        try {
            UpdateStaffResponse response = staffService.updateStaff(staffId, updateRequest);
            return ResponseEntity.ok().body(response);
        } catch (NotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    @PostMapping("/inactive/{staffId}")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> inactiveStaff(@PathVariable Long staffId) {
        int result = staffService.inactiveStaff(staffId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + staffId + " has been successfully inactivated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @PostMapping("/active/{staffId}")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> activeStaff(@PathVariable Long staffId) {
        int result = staffService.activeStaff(staffId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + staffId + " has been successfully activated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}