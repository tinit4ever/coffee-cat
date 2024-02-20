package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.*;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ShopService {
    List<ShopResponseGuest> getActiveShops(SortRequest sortRequest);
    List<ShopResponseGuest> searchShops(String keyword, String searchType, SortRequest sortRequest);
    ShopDetailResponse getShopDetails(Long id);
//    Page<ShopResponse> getPopularActiveShops(Integer page, Integer size);

    Page<ShopResponse> getShops(PaginationRequest pageRequest);
    CreateShopResponse createShop(ShopRequest request);
    UpdateShopResponse updateShop(Long shopId, ShopRequest updateRequest);
}