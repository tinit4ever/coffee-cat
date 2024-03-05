package com.swd.ccp.services_implementors;

import com.swd.ccp.models.request_models.CreateMenuItemRequest;
import com.swd.ccp.models.request_models.CreateMenuRequest;
import com.swd.ccp.models.request_models.DeleteMenuItemRequest;
import com.swd.ccp.models.request_models.UpdateMenuItemRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MenuServiceImpl implements MenuService {
    @Override
    public MenuItemListResponse getMenuItemList() {
        //---------------------------------------------------------------------------------
        //
        // concept: get all the menu items which have status available
        // requirement: none
        // problems:
        //      --
        //
        // steps:
        //      --
        //---------------------------------------------------------------------------------

        return null;
    }

    @Override
    public CreateMenuItemResponse createMenuItem(CreateMenuItemRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: create 1 item per time
        // requirement: list item {name, price, imgLink, description,
        //              discount: default 0, soldQuantity: default 0} (menu item)
        // problems:
        //      -- Name can not duplicated with available ones
        //
        // steps:
        //      -- Create a menu as default
        //      --
        //      --
        //---------------------------------------------------------------------------------

        return null;
    }

    @Override
    public UpdateMenuItemResponse updateMenuItem(UpdateMenuItemRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: update 1 item per time
        // requirement:
        // problems:
        //      --
        //
        // steps:
        //      --
        //---------------------------------------------------------------------------------

        return null;
    }

    @Override
    public DeleteMenuItemResponse deleteMenuItem(DeleteMenuItemRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: delete 1 item per time
        // requirement:
        // problems:
        //      --
        //
        // steps:
        //      --
        //---------------------------------------------------------------------------------

        return null;
    }

    @Override
    public CreateMenuResponse createMenu(CreateMenuRequest request) {
        //---------------------------------------------------------------------------------
        //
        // concept: create a menu after shop created
        // requirement:
        // problems:
        //      --
        //
        // steps:
        //      --
        //---------------------------------------------------------------------------------

        return null;
    }
}
