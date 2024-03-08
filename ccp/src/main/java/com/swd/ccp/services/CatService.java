package com.swd.ccp.services;

import com.swd.ccp.models.request_models.CreateCatRequest;
import com.swd.ccp.models.request_models.DeleteCatRequest;
import com.swd.ccp.models.response_models.CatListResponse;
import com.swd.ccp.models.response_models.CatShopListResponse;
import com.swd.ccp.models.response_models.CreateCatResponse;
import com.swd.ccp.models.response_models.DeleteCatResponse;

public interface CatService {
    CatShopListResponse getCatList();

    CreateCatResponse createCat(CreateCatRequest request);

    DeleteCatResponse deleteCat(DeleteCatRequest request);
}
