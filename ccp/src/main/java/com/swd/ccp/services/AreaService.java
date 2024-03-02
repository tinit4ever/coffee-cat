package com.swd.ccp.services;

import com.swd.ccp.models.request_models.GetAreaListRequest;
import com.swd.ccp.models.response_models.AreaListResponse;

public interface AreaService {

   AreaListResponse getAreasWithSeatsAndActiveCats(GetAreaListRequest request);
}
