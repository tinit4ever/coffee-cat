package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.CatResponse;
import org.springframework.data.domain.Page;

public interface CatService {
    Page<CatResponse> getActiveCats(Integer shopId, PaginationRequest pageRequest);
    CatResponse getCatDetails(Long id);
}
