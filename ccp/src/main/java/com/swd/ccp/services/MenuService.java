package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.MenuItemListResponse;
import com.swd.ccp.models.response_models.MenuItemResponse;
import org.springframework.data.domain.Page;

import java.util.List;

public interface MenuService {
    MenuItemListResponse getActiveMenus(Integer shopId, SortRequest sortRequest);
}
