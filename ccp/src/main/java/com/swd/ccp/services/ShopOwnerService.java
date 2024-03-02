package com.swd.ccp.services;

import com.swd.ccp.models.request_models.ChangeStatusStaffRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.request_models.CreateStaffRequest;
import com.swd.ccp.models.request_models.UpdateStaffRequest;
import com.swd.ccp.models.response_models.ChangeStatusStaffResponse;
import com.swd.ccp.models.response_models.CreateStaffResponse;
import com.swd.ccp.models.response_models.StaffListResponse;
import com.swd.ccp.models.response_models.UpdateStaffResponse;

public interface ShopOwnerService {

    StaffListResponse getStaffList(SortStaffListRequest request);
    CreateStaffResponse createStaff(CreateStaffRequest request);
    UpdateStaffResponse updateStaff(UpdateStaffRequest request);
    ChangeStatusStaffResponse changeStatusStaff(ChangeStatusStaffRequest request, String type);
}
