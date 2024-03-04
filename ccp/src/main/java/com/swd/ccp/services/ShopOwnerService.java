package com.swd.ccp.services;

import com.swd.ccp.models.request_models.*;
import com.swd.ccp.models.response_models.*;

public interface ShopOwnerService {

    StaffListResponse getStaffList(SortStaffListRequest request);
    CreateStaffResponse createStaff(CreateStaffRequest request);
    UpdateStaffResponse updateStaff(UpdateStaffRequest request);
    ChangeStatusStaffResponse changeStatusStaff(ChangeStatusStaffRequest request, String type);

    UpdateShopResponse updateShop(UpdateShopRequest request);

    CreateAreaResponse createAreaAndTable(CreateAreaRequest request);
}
