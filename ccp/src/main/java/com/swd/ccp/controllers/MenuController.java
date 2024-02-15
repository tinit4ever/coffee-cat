package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.MenuItemResponse;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
public class MenuController {
    private final MenuService menuService;
    @GetMapping("/list-menu-item")
    @PreAuthorize("hasAuthority('customer:read')")
    public Page<MenuItemResponse> getActiveShops(@RequestParam Integer shopId,@RequestBody PaginationRequest pageRequest) {
        Page<MenuItemResponse> page = menuService.getActiveMenus(shopId,pageRequest);
        LOGGER.info("get list successfully");
        return page;
    }
}
