package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {
    private final ShopStatusRepo shopStatusRepo;
    private final ShopRepo shopRepo;

    private final SeatRepo seatRepo;
    private final SeatStatusRepo seatStatusRepo;
    private final ShopImageRepo shopImageRepo;
    private final MenuItemRepo menuItemRepo;
    private final MenuItemStatusRepo menuItemStatusRepo;
    private final MenuRepo menuRepo;
    private final AreaRepo areaRepo;

    private static final String ACTIVE = "opened";


    @Override
    public ShopListResponse getActiveShops(SortRequest sortRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);
        if (activeStatusList.isEmpty()) {
            return new ShopListResponse(Collections.emptyList(), false, "No active shops found");
        }

        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
        List<Shop> shopList = shopRepo.findAllByStatusIn(activeStatusList, sort);

        List<ShopResponseGuest> mappedshopList = mapToShopDtoList(shopList);


        boolean status = true;
        String message = "Successfully retrieved shop list";
        return new ShopListResponse(mappedshopList, status, message);
    }



    public List<MenuItemResponse> getMenuItemListFromShop(Shop shop) {
        List<Menu> menus = menuRepo.findByShop(shop);
        List<MenuItemResponse> menuItemResponses = new ArrayList<>();
        for (Menu menu : menus) {
            List<MenuItem> menuItems = menuItemRepo.findByMenu(menu);
            for (MenuItem menuItem : menuItems) {
                MenuItemStatus activeMenuItemStatus = menuItemStatusRepo.findByStatus("available").orElse(null);

                if (activeMenuItemStatus != null && menuItem.getMenuItemStatus().equals(activeMenuItemStatus)) {
                    MenuItemResponse menuItemResponse = new MenuItemResponse();
                    menuItemResponse.setId(menuItem.getId());
                    menuItemResponse.setName(menuItem.getName());
                    menuItemResponse.setImgLink(menuItem.getImgLink());
                    menuItemResponse.setDescription(menuItem.getDescription());
                    menuItemResponse.setPrice((int) menuItem.getPrice());
                    menuItemResponse.setSoldQuantity(menuItem.getSoldQuantity());
                    menuItemResponses.add(menuItemResponse);
                }
            }
        }
        return menuItemResponses;
    }

    @Override
    public ShopListResponse searchShops(String keyword, String searchType, SortRequest sortRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);
        if (activeStatusList.isEmpty()) {
            return new ShopListResponse(Collections.emptyList(), false, "No active shops found");
        }

        List<Shop> searchResults;
        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
        if ("name".equalsIgnoreCase(searchType)) {
            searchResults = shopRepo.findAllByStatusInAndNameContainingIgnoreCase(activeStatusList, keyword, sort);
        } else if ("address".equalsIgnoreCase(searchType)) {
            searchResults = shopRepo.findAllByStatusInAndAddressContainingIgnoreCase(activeStatusList, keyword, sort);
        } else {

            return new ShopListResponse(Collections.emptyList(), false, "Invalid search type");
        }

        boolean status = true;
        String message = "Successfully retrieved shop list";
        List<ShopResponseGuest> mappedshopList = mapToShopDtoList(searchResults);
        return new ShopListResponse(mappedshopList, status, message);
    }

    private List<ShopResponseGuest> mapToShopDtoList(List<Shop> shops) {
        if (shops == null) {
            throw new IllegalArgumentException("Argument cannot be null");
        }

        if (shops.isEmpty()) {
            return Collections.emptyList();
        }

        return shops.stream().map(shop -> {
            ShopResponseGuest shopResponse = new ShopResponseGuest();
            shopResponse.setId(shop.getId());
            shopResponse.setName(shop.getName());
            shopResponse.setRating(shop.getRating());
            List<String> imageLinks = shop.getShopImageList().stream()
                    .map(ShopImage::getLink)
                    .collect(Collectors.toList());
            shopResponse.setShopImageList(imageLinks);
            shopResponse.setAddress(shop.getAddress());
            shopResponse.setPhone(shop.getPhone());
            shopResponse.setAvatar(shop.getAvatar());
            shopResponse.setCommentList(shop.getCommentList().stream().map(Comment::getComment)
                    .collect(Collectors.toList()));
            shopResponse.setOpenTime(shop.getOpenTime());
            shopResponse.setCloseTime(shop.getCloseTime());

            List<MenuItemResponse> menuItemList = getMenuItemListFromShop(shop);
            shopResponse.setMenuItemList(menuItemList);

            if (shop.getAddress() == null) {
                shopResponse.setAddress("N/A");
            }
            if (shop.getOpenTime() == null) {
                shopResponse.setOpenTime("N/A");
            }
            if (shop.getCloseTime() == null) {
                shopResponse.setCloseTime("N/A");
            }
            if (shop.getPhone() == null) {
                shopResponse.setPhone("N/A");
            }
            if (shop.getName() == null) {
                shopResponse.setName("N/A");
            }
            if (shop.getRating() == null) {
                shopResponse.setRating(0.0);
            }

            return shopResponse;
        }).collect(Collectors.toList());
    }


    @Override
    public ShopManageResponse getShops(SortRequest sortRequest) {



        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
        List<Shop> shopList = shopRepo.findAll(sort);

        List<ShopResponse> mappedshopList = mapToShopList(shopList);


        boolean status = true;
        String message = "Successfully retrieved shop list";
        return new ShopManageResponse(mappedshopList, status, message);
    }

    private List<ShopResponse> mapToShopList(List<Shop> shops) {
        if (shops == null) {
            throw new IllegalArgumentException("Argument cannot be null");
        }

        if (shops.isEmpty()) {
            return Collections.emptyList();
        }

        return shops.stream().map(shop -> {
            ShopResponse shopResponse = new ShopResponse();
            shopResponse.setName(shop.getName());
            shopResponse.setRating(shop.getRating());
            List<String> imageLinks = shop.getShopImageList().stream()
                    .map(ShopImage::getLink)
                    .collect(Collectors.toList());
            shopResponse.setShopImageList(imageLinks);
            shopResponse.setAvatar(shop.getAvatar());
            if (shop.getName() == null) {
                shopResponse.setName("N/A");
            }
            return shopResponse;
        }).collect(Collectors.toList());
    }

    @Override
    public CreateShopResponse createShop(ShopRequest request) {
        if (isStringValid(request.getName())) {
            Shop shop = shopRepo.findByName(request.getName());

            if (shop == null) {
                ShopStatus inactiveStatus = shopStatusRepo.findById(2).orElse(null);

                shop = shopRepo.save(
                        Shop.builder()
                                .phone(request.getPhone())
                                .name(request.getName())
                                .avatar(request.getAvatar())
                                .status(inactiveStatus)
                                .address(request.getAddress())
                                .openTime(request.getOpenTime())
                                .closeTime(request.getCloseTime())
                                .build()
                );

                int areaCount = 10;
                List<Area> areaList = new ArrayList<>();
                for (int i = 0; i < areaCount; i++) {

                    Area area = Area.builder()
                            .name("Area " + (i + 1))
                            .build();
                    areaList.add(area);
                }
                areaRepo.saveAll(areaList);

                List<ShopImage> shopImageList = new ArrayList<>();
                for (ShopImage shopImage : request.getShopImageList()) {
                    ShopImage newShopImage = ShopImage.builder()
                            .shop(shop)
                            .link(shopImage.getLink())
                            .build();
                    shopImageList.add(newShopImage);
                }

                shopImageRepo.saveAll(shopImageList);

                return CreateShopResponse.builder()
                        .message("Create a successful shop")
                        .status(true)
                        .build();
            }
            return CreateShopResponse.builder()
                    .status(false)
                    .build();
        }
        return CreateShopResponse.builder()
                .status(false)
                .build();
    }

    @Override
    public UpdateShopResponse updateShop(Long shopId, ShopRequest updateRequest) {
        Optional<Shop> optionalShop = shopRepo.findById(shopId);
        if (optionalShop.isPresent()) {
            Shop shop = optionalShop.get();
            if (updateRequest.getAddress() != null) {
                shop.setAddress(updateRequest.getAddress());
            }
            if (updateRequest.getName() != null) {
                shop.setName(updateRequest.getName());
            }
            if (updateRequest.getPhone() != null) {
                shop.setPhone(updateRequest.getPhone());
            }
            if (updateRequest.getOpenTime() != null) {
                shop.setOpenTime(updateRequest.getOpenTime());
            }
            if (updateRequest.getCloseTime() != null) {
                shop.setCloseTime(updateRequest.getCloseTime());
            }

            shopRepo.save(shop);

            UpdateShopResponse response = new UpdateShopResponse();
            response.setShopId(shopId);
            response.setMessage("Shop information updated successfully.");
            response.setStatus(true);

            return response;
        } else {
            throw new NotFoundException("Shop with id " + shopId + " not found.");
        }

    }
    @Override
    public int inactiveShop(Integer shopId) {
        if (shopId == null) return 0;

        try {
            Shop shop = shopRepo.findById(shopId).orElse(null);

            if(shop == null) return 0;

            ShopStatus inactiveStatus = shopStatusRepo.findById(3).orElse(null);

            if (inactiveStatus == null) {
                throw new IllegalStateException("Inactive status not found.");
            }

            shop.setStatus(inactiveStatus);

            shopRepo.save(shop);

            LOGGER.info("Inactive successfully");

            return 1;
        } catch (Exception e) {
            LOGGER.error("Inactive failed");

            throw new IllegalStateException("Staff inactive failed", e);
        }
    }
    @Override
    public int activeShop(Integer shopId) {
        if (shopId == null) return 0;

        try {
            Shop shop = shopRepo.findById(shopId).orElse(null);

            if(shop == null) return 0;

            ShopStatus activeStatus = shopStatusRepo.findById(1).orElse(null);

            if (activeStatus == null) {
                throw new IllegalStateException("active status not found.");
            }

            shop.setStatus(activeStatus);

            shopRepo.save(shop);

            LOGGER.info("active successfully");

            return 1;
        } catch (Exception e) {
            LOGGER.error("active failed");

            throw new IllegalStateException("Staff active failed", e);
        }
    }
    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }
}
