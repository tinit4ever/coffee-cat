package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
        ShopListResponse activeShops = shopService.getActiveShops(sortStaffListRequest);
        return ResponseEntity.ok(activeShops);
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
        ShopListResponse shops = shopService.searchShops(keyword, searchType, sortStaffListRequest);
        return ResponseEntity.ok(shops);
    }
}