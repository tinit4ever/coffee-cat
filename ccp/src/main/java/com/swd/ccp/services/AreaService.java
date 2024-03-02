package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.request_models.GetAreaListRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;

import java.util.Date;
import java.util.List;

public interface AreaService {

   AreaListResponse getAreasWithSeatsAndActiveCats(GetAreaListRequest request);
}
