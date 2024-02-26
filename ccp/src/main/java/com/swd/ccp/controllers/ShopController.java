package com.swd.ccp.controllers;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequiredArgsConstructor
public class ShopController {
    private final ShopService shopService;

    @GetMapping("auth/list-shop")
    public ResponseEntity<ShopListResponse> getActiveShops(@RequestParam(value = "sortByColumn", defaultValue = "name") String sortByColumn,
                                                             @RequestParam(value = "asc", defaultValue = "true") boolean ascending) {
        SortRequest sortRequest = new SortRequest(ascending, sortByColumn);
        ShopListResponse activeShops = shopService.getActiveShops(sortRequest);
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
        SortRequest sortRequest = new SortRequest(asc, sortByColumn);
        ShopListResponse shops = shopService.searchShops(keyword, searchType, sortRequest);
        return ResponseEntity.ok(shops);
    }


    @GetMapping("/shop")
    @PreAuthorize("hasAuthority('owner:read')")
    public Page<ShopResponse> getShops(@RequestBody PaginationRequest pageRequest) {
        Page<ShopResponse> page = shopService.getShops(pageRequest);
        LOGGER.info("get list successfully");
        return page;
    }
//    @PostMapping("auth/createShop")
//    public ResponseEntity<CreateShopResponse> createStaff(@RequestBody ShopRequest request) {
//        CreateShopResponse response = shopService.createShop(request) ;
//        if (response.isStatus()) {
//            return ResponseEntity.ok(response);
//        } else {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
//        }
//    }
    @PostMapping("updateShop/{shopId}")
    public ResponseEntity<UpdateShopResponse> updateStaff(@PathVariable Long shopId,
                                                           @RequestBody ShopRequest updateRequest) {
        try {
            UpdateShopResponse response = shopService.updateShop(shopId, updateRequest);
            return ResponseEntity.ok().body(response);
        } catch (NotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    @PostMapping("auth/inactive/{shopId}")
//    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> inactiveStaff(@PathVariable Integer shopId) {
        int result = shopService.inactiveShop(shopId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + shopId + " has been successfully inactivated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @PostMapping("auth/active/{shopId}")
//    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<String> activeStaff(@PathVariable Integer shopId) {
        int result = shopService.activeShop(shopId);
        if (result == 1) {
            return ResponseEntity.ok("Staff with ID " + shopId + " has been successfully activated.");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}