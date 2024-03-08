package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CreateMenuItemRequest;
import com.swd.ccp.models.request_models.DeleteMenuItemRequest;
import com.swd.ccp.models.request_models.UpdateMenuItemRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/menu")
public class MenuController {

    private final MenuService menuService;


    @GetMapping("/list")
    @PreAuthorize("hasAuthority('owner:read')")
    public ResponseEntity<MenuItemListResponse> getMenuItemList(){
        return ResponseEntity.ok().body(menuService.getMenuItemList());
    }

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateMenuItemResponse> createMenuItem(@RequestBody CreateMenuItemRequest request){
        return ResponseEntity.ok().body(menuService.createMenuItem(request));
    }

    @PostMapping("/update")
    @PreAuthorize("hasAuthority('owner:update')")
    public ResponseEntity<UpdateMenuItemResponse> createMenuItem(@RequestBody UpdateMenuItemRequest request){
        return ResponseEntity.ok().body(menuService.updateMenuItem(request));
    }

    @PostMapping("/delete")
    @PreAuthorize("hasAuthority('owner:delete')")
    public ResponseEntity<DeleteMenuItemResponse> deleteMenuItem(@RequestBody DeleteMenuItemRequest request){
        return ResponseEntity.ok().body(menuService.deleteMenuItem(request));
    }
}
