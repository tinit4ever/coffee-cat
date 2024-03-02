package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {
    private final ShopStatusRepo shopStatusRepo;
    private final ShopRepo shopRepo;
    private final ShopImageRepo shopImageRepo;
    private final MenuItemRepo menuItemRepo;
    private final MenuItemStatusRepo menuItemStatusRepo;
    private final MenuRepo menuRepo;
    private final AreaRepo areaRepo;

    private static final String ACTIVE = "opened";


    @Override
    public ShopListResponse getActiveShops(SortStaffListRequest sortStaffListRequest) {
        return null;
    }



    public List<MenuItemResponse> getMenuItemListFromShop(Shop shop) {
        return null;
    }

    @Override
    public ShopListResponse searchShops(String keyword, String searchType, SortStaffListRequest sortStaffListRequest) {
        return null;
    }

    private List<ShopResponseGuest> mapToShopDtoList(List<Shop> shops) {
        return null;
    }


    @Override
    public ShopManageResponse getShops(SortStaffListRequest sortStaffListRequest) {
        return null;
    }

    private List<ShopResponse> mapToShopList(List<Shop> shops) {
        return null;
    }

    @Override
    public CreateShopResponse createShop(ShopRequest request) {
        return null;
    }

    @Override
    public UpdateShopResponse updateShop(Long shopId, ShopRequest updateRequest) {
        return null;
    }
    @Override
    public int inactiveShop(Integer shopId) {
        return 0;
    }
    @Override
    public int activeShop(Integer shopId) {
        return 0;
    }
    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }
}
