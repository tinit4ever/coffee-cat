package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.MenuItemResponse;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
public class MenuController {
    private final MenuService menuService;
    @GetMapping("/list-menu-item")
    @PreAuthorize("hasAnyRole('ROLE_CUSTOMER')")
    public Page<MenuItemResponse> getActiveShops(@RequestBody PaginationRequest pageRequest) {
        Page<MenuItemResponse> page = menuService.getActiveMenus(pageRequest);
        LOGGER.info("get list successfully");
        return page;
    }
}
