package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CreateShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.CreateShopResponse;
import com.swd.ccp.models.response_models.ShopListResponse;
import com.swd.ccp.models.response_models.ShopProfileResponse;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class ShopController {
    private final ShopService shopService;

    @GetMapping("auth/list-shop")
    public ResponseEntity<ShopListResponse> getActiveShops(@RequestParam(value = "sortByColumn", defaultValue = "name") String sortByColumn,
                                                             @RequestParam(value = "asc", defaultValue = "true") boolean ascending) {
        SortStaffListRequest sortStaffListRequest = new SortStaffListRequest(ascending, sortByColumn);
        return ResponseEntity.ok().body(shopService.getActiveShops(sortStaffListRequest));
    }
    @GetMapping("auth/search")
    public ResponseEntity<ShopListResponse> searchShops(
            @RequestParam String keyword,
            @RequestParam String searchType,
            @RequestParam(value = "sortByColumn", defaultValue = "name") String sortByColumn,
            @RequestParam(value = "asc", defaultValue = "true") boolean asc
    )
    {
        SortStaffListRequest sortStaffListRequest = new SortStaffListRequest(asc, sortByColumn);
        return ResponseEntity.ok().body(shopService.searchShops(keyword, searchType, sortStaffListRequest));
    }

    @PostMapping("/shop/create")
    @PreAuthorize("hasAuthority('admin:create')")
    public ResponseEntity<CreateShopResponse> createShop(@RequestBody CreateShopRequest request) throws Exception{
        return ResponseEntity.ok().body(shopService.createShop(request));
    }

    @GetMapping("/shop/profile")
    @PreAuthorize("hasAuthority('owner:read')")
    public ResponseEntity<ShopProfileResponse> getShopProfile(){
        return ResponseEntity.ok().body(shopService.getShopProfile());
    }
}