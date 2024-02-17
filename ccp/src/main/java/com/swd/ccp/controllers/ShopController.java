package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.ShopDetailResponse;
import com.swd.ccp.models.response_models.ShopResponse;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class ShopController {
    private final ShopService shopService;

    @GetMapping("/list-shop")
    public Page<ShopResponse> getActiveShops(@RequestBody PaginationRequest pageRequest) {
        Page<ShopResponse> page = shopService.getActiveShops(pageRequest);
        LOGGER.info("get list successfully");
        return page;

    }
    @GetMapping("/shop-search")
    public Page<ShopResponse> searchShops(@RequestParam String keyword, @RequestParam String searchType,@RequestBody PaginationRequest pageRequest) {
        return shopService.searchShops(keyword, searchType, pageRequest);
    }

    @GetMapping("/shops/{id}")
    public ResponseEntity<ShopDetailResponse> getShopDetails(@PathVariable Long id) {
        ShopDetailResponse shopDetailResponse = shopService.getShopDetails(id);
        if (shopDetailResponse != null) {
            return ResponseEntity.ok(shopDetailResponse);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    @GetMapping("/shop")
    @PreAuthorize("hasAuthority('owner:read')")
    public Page<ShopResponse> getShops(@RequestBody PaginationRequest pageRequest) {
        Page<ShopResponse> page = shopService.getShops(pageRequest);
        LOGGER.info("get list successfully");
        return page;

    }
}