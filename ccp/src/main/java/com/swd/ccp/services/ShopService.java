package com.swd.ccp.services;

import com.swd.ccp.models.request_models.CreateShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.*;

public interface ShopService {
    ShopListResponse getActiveShops(SortStaffListRequest request);
    ShopListResponse searchShops(String keyword, String searchType, SortStaffListRequest request);
    CreateShopResponse createShop(CreateShopRequest request) throws Exception;

    ShopProfileResponse getShopProfile();
}