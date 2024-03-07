package com.swd.ccp.services;

import com.swd.ccp.models.request_models.CreateMenuItemRequest;
import com.swd.ccp.models.request_models.CreateMenuRequest;
import com.swd.ccp.models.request_models.DeleteMenuItemRequest;
import com.swd.ccp.models.request_models.UpdateMenuItemRequest;
import com.swd.ccp.models.response_models.*;

public interface MenuService {
    MenuItemListResponse getMenuItemList();

    CreateMenuItemResponse createMenuItem(CreateMenuItemRequest request);

    DeleteMenuItemResponse deleteMenuItem(DeleteMenuItemRequest request);

    UpdateMenuItemResponse upadateMenuItem(UpdateMenuItemRequest request);
}
