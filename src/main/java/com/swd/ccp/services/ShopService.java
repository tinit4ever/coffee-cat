package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.ShopDetailResponse;
import com.swd.ccp.models.response_models.ShopResponse;
import org.springframework.data.domain.Page;

public interface ShopService {
    Page<ShopResponse> getActiveShops(PaginationRequest pageRequest);
    Page<ShopResponse> searchShops(String keyword, String searchType,PaginationRequest pageRequest);
    ShopDetailResponse getShopDetails(Long id);
//    Page<ShopResponse> getPopularActiveShops(Integer page, Integer size);


}