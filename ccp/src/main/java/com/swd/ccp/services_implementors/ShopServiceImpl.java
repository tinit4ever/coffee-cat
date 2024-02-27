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
    private final CatStatusRepo catStatusRepo;
    private final AccountService accountService;
    private final SeatRepo seatRepo;
    private final SeatStatusRepo seatStatusRepo;
    private final ShopImageRepo shopImageRepo;
    private final CatRepo catRepo;
    private final MenuItemRepo menuItemRepo;
    private final MenuItemStatusRepo menuItemStatusRepo;
    private final MenuRepo menuRepo;
    private final AreaStatusRepo areaStatusRepo;
    private final AreaRepo areaRepo;
    private static final String ACTIVE = "opened";
    private static final String SeatActive = "available";
    private static final String CATACTIVE = "active";

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

    private AreaResponse mapToAreaResponse(Shop shop) {
        AreaResponse areaResponse = new AreaResponse();
        List<AreaStatus> activeAreaStatusList = areaStatusRepo.findAllByStatus("active");
        List<Area> activeAreas = areaRepo.findAllByShopAndAreaStatusIn(shop, activeAreaStatusList);

        // Lấy tên của khu vực nếu cần
        // areaResponse.setName(a);

        List<CatResponse> catList = mapToCatResponseList(activeAreas);
        areaResponse.setCatList(catList);

        List<SeatResponse> seatList = mapToSeatResponseList(activeAreas);
        areaResponse.setSeatList(seatList);

        List<MenuResponse> menuList = mapToMenuResponseList(shop);
        areaResponse.setMenuList(menuList);

        return areaResponse;
    }

    private List<MenuResponse> mapToMenuResponseList(Shop shop) {
        List<MenuResponse> menuList = new ArrayList<>();
        List<Menu> menus = menuRepo.findByShop(shop);
        for (Menu menu : menus) {
            MenuResponse menuResponse = new MenuResponse();
            menuResponse.setDescription(menu.getDescription());
            List<MenuItemResponse> menuItemList = mapToMenuItemResponseList(menu.getMenuItemList());
            menuResponse.setMenuItemList(menuItemList);
            menuList.add(menuResponse);
        }
        return menuList;
    }
    private List<CatResponse> mapToCatResponseList(List<Area> areaList) {
        List<CatResponse> catResponseList = new ArrayList<>();
        for (Area area : areaList) {
            List<CatStatus> activeCatStatusList = catStatusRepo.findAllByStatus(CATACTIVE);
            List<Cat> catsInArea = catRepo.findAllByAreaAndCatStatusIn(area, activeCatStatusList);
            List<CatResponse> catResponses = mapCatsToCatResponses(catsInArea);
            catResponseList.addAll(catResponses);
        }
        return catResponseList;
    }

    private List<CatResponse> mapCatsToCatResponses(List<Cat> catList) {
        List<CatResponse> catResponses = new ArrayList<>();
        for (Cat cat : catList) {
            CatResponse catResponse = mapCatToCatResponse(cat);
            catResponses.add(catResponse);
        }
        return catResponses;
    }

    private CatResponse mapCatToCatResponse(Cat cat) {
        CatResponse catResponse = new CatResponse();
        catResponse.setId(cat.getId());
        catResponse.setDescription(cat.getDescription());
        catResponse.setType(cat.getType());
        catResponse.setImgLink(cat.getImgLink());
        return catResponse;
    }
    private List<SeatResponse> mapToSeatResponseList(List<Area> areaList) {
        List<SeatResponse> seatResponseList = new ArrayList<>();
        for (Area area : areaList) {
            Collection<SeatStatus> activeSeatStatusList = seatStatusRepo.findAllByStatus(SeatActive);
            List<Seat> seatsInArea = seatRepo.findAllByAreaAndSeatStatusIn(area, activeSeatStatusList);
            List<SeatResponse> seatResponses = mapSeatsToSeatResponses(seatsInArea);
            seatResponseList.addAll(seatResponses);
        }
        return seatResponseList;
    }

    private List<SeatResponse> mapSeatsToSeatResponses(List<Seat> seatList) {
        List<SeatResponse> seatResponses = new ArrayList<>();
        for (Seat seat : seatList) {

            SeatResponse seatResponse = mapSeatToSeatResponse(seat);
            seatResponses.add(seatResponse);
        }
        return seatResponses;
    }

    private SeatResponse mapSeatToSeatResponse(Seat seat) {
        SeatResponse seatResponse = new SeatResponse();
        seatResponse.setId(seat.getId());
        seatResponse.setName(seat.getName());
        return seatResponse;
    }
      /*List<Seat> activeSeats = seatRepo.findAllByShopAndSeatStatusIn(shop, activeSeatStatusList);
            shopResponse.setSeatList(activeSeats.stream().map(Seat::getName).collect(Collectors.toList()));*/

    private List<MenuItemResponse> mapToMenuItemResponseList(List<MenuItem> menuItemList) {
        return menuItemList.stream()
                .filter(menuItem -> menuItem.getMenuItemStatus().getId().equals(1))
                .map(menuItem -> {
                    MenuItemResponse menuItemResponse = new MenuItemResponse();
                    menuItemResponse.setId(menuItem.getId());
                    menuItemResponse.setName(menuItem.getName());
                    menuItemResponse.setPrice(menuItem.getPrice());
                    return menuItemResponse;
                })
                .collect(Collectors.toList());
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

            // Ánh xạ đối tượng AreaResponse cho cửa hàng (shop)
            AreaResponse area = mapToAreaResponse(shop);
            shopResponse.setAreaList(area);

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
    public Page<ShopResponse> getShops(PaginationRequest pageRequest) {

        Pageable pageable = PageRequest.of(
                pageRequest.getPageNo(),
                pageRequest.getPageSize(),
                Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                        pageRequest.getSortByColumn())
        );

        Page<Shop> shopList = shopRepo.findAll(pageable);

        List<ShopResponse> shopDtoList = mapToShopList(shopList.getContent());

        return new PageImpl<>(shopDtoList, pageable, shopList.getTotalElements());
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
            shopResponse.setStatus(true);
            shopResponse.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));
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

                SeatStatus inactiveSeatStatus = seatStatusRepo.findById(1).orElse(null);
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

                int seatCount = 10;
                int seatCapacity = 4;
                List<Seat> seatList = new ArrayList<>();
                for (int i = 0; i < seatCount; i++) {
                    // Tạo chỗ ngồi mới
                    Seat seat = Seat.builder()
                            .name("Seat " + (i + 1))
                            .capacity(seatCapacity)
                            .seatStatus(inactiveSeatStatus)
                            .build();
                    seatList.add(seat);
                }
                seatRepo.saveAll(seatList);

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
            response.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));

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
