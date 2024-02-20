package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.MenuItemListResponse;
import com.swd.ccp.models.response_models.MenuItemResponse;
import com.swd.ccp.models.response_models.ShopResponseGuest;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
public class MenuController {
    private final MenuService menuService;
    @GetMapping("/list-menu-item")
    @PreAuthorize("hasAuthority('customer:read')")
    public ResponseEntity<MenuItemListResponse> getActiveMenus(@RequestParam(value = "sortByColumn", defaultValue = "name") String sortByColumn,
                                                               @RequestParam(value = "asc", defaultValue = "true") boolean ascending,
                                                               @RequestParam Integer shopId) {
        SortRequest sortRequest = new SortRequest(ascending, sortByColumn);
        MenuItemListResponse activeMenus = menuService.getActiveMenus(shopId,sortRequest);
        return ResponseEntity.ok(activeMenus);
    }
}
