package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.MenuItemResponse;
import org.springframework.data.domain.Page;

public interface MenuService {
    Page<MenuItemResponse> getActiveMenus(PaginationRequest pageRequest);
}
