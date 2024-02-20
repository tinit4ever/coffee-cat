package com.swd.ccp.services;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.CatListResponse;
import com.swd.ccp.models.response_models.CatResponse;
import org.springframework.data.domain.Page;

import java.util.List;

public interface CatService {
    CatListResponse getActiveCats(Integer shopId, SortRequest sortRequest);
    CatResponse getCatDetails(Long id);
}
