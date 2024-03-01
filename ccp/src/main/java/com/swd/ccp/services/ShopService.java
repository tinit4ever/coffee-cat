package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.*;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ShopService {
    ShopListResponse getActiveShops(SortRequest sortRequest);
    ShopListResponse searchShops(String keyword, String searchType, SortRequest sortRequest);
  ;
//    Page<ShopResponse> getPopularActiveShops(Integer page, Integer size);

    ShopManageResponse getShops(SortRequest sortRequest);
    CreateShopResponse createShop(ShopRequest request);
    UpdateShopResponse updateShop(Long shopId, ShopRequest updateRequest);
    int inactiveShop(Integer shopId);
    int activeShop(Integer shopId);
}