package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.*;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.ShopOwnerService;
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
    public ResponseEntity<StaffListResponse> GetStaffList(@RequestBody SortStaffListRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.getStaffList(request));
    }

    @PostMapping("/staff/create")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateStaffResponse> createStaff(@RequestBody CreateStaffRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.createStaff(request));
    }
    @PostMapping("/staff/update")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<UpdateStaffResponse> updateStaff(@RequestBody UpdateStaffRequest updateRequest) {
            return ResponseEntity.ok().body(shopOwnerService.updateStaff(updateRequest));

    }
    @PostMapping("/staff/inactive")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<ChangeStatusStaffResponse> inactiveStaff(@RequestBody ChangeStatusStaffRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.changeStatusStaff(request, "ban"));
    }
    @PostMapping("/staff/active")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<ChangeStatusStaffResponse> activeStaff(@RequestBody ChangeStatusStaffRequest request) {
        return ResponseEntity.ok().body(shopOwnerService.changeStatusStaff(request, "unban"));
    }

    @PostMapping("/shop/update")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<UpdateShopResponse> updateShop(@RequestBody UpdateShopRequest request){
        return ResponseEntity.ok().body(shopOwnerService.updateShop(request));
    }

    @PostMapping("/area/create")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateAreaResponse> createAreaAndTable(@RequestBody CreateAreaRequest request){
        return ResponseEntity.ok().body(shopOwnerService.createAreaAndTable(request));
    }

    @PostMapping("/area/delete")
    @PreAuthorize("hasAuthority('owner:delete')")
    public ResponseEntity<DeleteAreaResponse> deleteAreaAndTable(@RequestBody DeleteAreaRequest request){
        return ResponseEntity.ok().body(shopOwnerService.deleteArea(request));
    }
}
