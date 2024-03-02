package com.swd.ccp.services;

import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.request_models.StaffRequest;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;

public interface ShopOwnerService {

    StaffListResponse getStaffList(SortRequest request);
    CreateStaffResponse createStaff(StaffRequest request);
    UpdateStaffResponse updateStaff(Integer staffId, StaffRequest updateRequest);
    int inactiveStaff(Integer staffId);
    int activeStaff(Integer staffId);
}
