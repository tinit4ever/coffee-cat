package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.request_models.*;
import com.swd.ccp.models.response_models.*;

public interface ShopOwnerService {

    StaffListResponse getStaffList(SortStaffListRequest request);
    CreateStaffResponse createStaff(CreateStaffRequest request);
    UpdateStaffResponse updateStaff(UpdateStaffRequest request);
    ChangeStatusStaffResponse changeStatusStaff(ChangeStatusStaffRequest request, String type);

    UpdateShopResponse updateShop(UpdateShopRequest request);

    CreateAreaResponse createAreaAndTable(CreateAreaRequest request);

    DeleteAreaResponse deleteArea(DeleteAreaRequest request);

    void createShopOwnerAccount(Account account, Shop shop);
}
