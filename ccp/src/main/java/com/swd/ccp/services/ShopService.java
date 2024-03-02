package com.swd.ccp.services;

import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.*;

public interface ShopService {
    ShopListResponse getActiveShops(SortStaffListRequest sortStaffListRequest);
    ShopListResponse searchShops(String keyword, String searchType, SortStaffListRequest sortStaffListRequest);
  ;
//    Page<ShopResponse> getPopularActiveShops(Integer page, Integer size);

    ShopManageResponse getShops(SortStaffListRequest sortStaffListRequest);
    CreateShopResponse createShop(ShopRequest request);
    UpdateShopResponse updateShop(Long shopId, ShopRequest updateRequest);
    int inactiveShop(Integer shopId);
    int activeShop(Integer shopId);
}