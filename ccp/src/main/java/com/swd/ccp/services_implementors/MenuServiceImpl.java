//package com.swd.ccp.services_implementors;
//
//import com.swd.ccp.models.entity_models.MenuItem;
//import com.swd.ccp.models.entity_models.MenuItemStatus;
//import com.swd.ccp.models.request_models.PaginationRequest;
//import com.swd.ccp.models.request_models.SortRequest;
//import com.swd.ccp.models.response_models.CatListResponse;
//import com.swd.ccp.models.response_models.CatResponse;
//import com.swd.ccp.models.response_models.MenuItemListResponse;
//import com.swd.ccp.models.response_models.MenuItemResponse;
//import com.swd.ccp.repositories.MenuItemRepo;
//import com.swd.ccp.repositories.MenuItemStatusRepo;
//import com.swd.ccp.services.AccountService;
//import com.swd.ccp.services.MenuService;
//import lombok.RequiredArgsConstructor;
//import org.springframework.data.domain.*;
//import org.springframework.stereotype.Service;
//
//import java.util.Collections;
//import java.util.List;
//import java.util.stream.Collectors;
//
//
//@Service
//@RequiredArgsConstructor
//public class MenuServiceImpl implements MenuService {
//    private final MenuItemStatusRepo menuItemStatusRepo;
//    private final MenuItemRepo menuItemRepo;
//    private final AccountService accountService;
//    private static final String ACTIVE = "available";
//
//    @Override
//    public MenuItemListResponse getActiveMenus(Integer shopId, SortRequest sortRequest) {
//        List<MenuItemStatus> activeStatusList = menuItemStatusRepo.findAllByStatus(ACTIVE);
//
//        if (activeStatusList.isEmpty()) {
//            return new MenuItemListResponse(Collections.emptyList(), false, null, "No MenuItem found");
//        }
//        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
//        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
//
//        List<MenuItem> menuItemList = menuItemRepo.findAllByMenuItemStatusIn(activeStatusList, sort);
//        List<MenuItemResponse> mappedMenuItemList = mapToMenuItemDtoList(menuItemList, shopId);
//
//        boolean status = true;
//        String message = "Successfully retrieved menuItem list";
//        String token = accountService.getAccessToken(accountService.getCurrentLoggedUser().getId());
//        return new MenuItemListResponse(mappedMenuItemList, status, message, token);
//    }
//
//    private List<MenuItemResponse> mapToMenuItemDtoList(List<MenuItem> menuItems, Integer shopId) {
//        if (menuItems == null) {
//            throw new IllegalArgumentException("Argument cannot be null");
//        }
//
//        if (menuItems.isEmpty()) {
//            return Collections.emptyList();
//        }
//
//        return menuItems.stream()
//                .filter(menuItem -> menuItem.getMenu().getShop().getId().equals(shopId)) // Lọc theo shopId
//                .map(menuItem -> {
//                    MenuItemResponse menuItemResponse = new MenuItemResponse();
//                    menuItemResponse.setName(menuItem.getName());
//                    menuItemResponse.setDescription(menuItem.getDescription());
//                    menuItemResponse.setDiscount(menuItem.getDiscount());
//                    menuItemResponse.setPrice(menuItem.getPrice());
//                    menuItemResponse.setQuantity(menuItem.getQuantity());
//                    menuItemResponse.setImgLink(menuItem.getImgLink());
//                    menuItemResponse.setSoldQuantity(menuItem.getQuantity());
//                    menuItemResponse.setStatus(true);
//                    menuItemResponse.setToken(accountService.getAccessToken(accountService.getCurrentLoggedUser().getId()));
//            if (menuItem.getName() == null) {
//                menuItemResponse.setName("N/A");
//            }
//            if (menuItem.getDescription() == null) {
//                menuItemResponse.setDescription("N/A");
//            }
//            if (Float.isNaN(menuItem.getDiscount())) {
//                menuItemResponse.setDiscount(0.0f);
//            }
//            if (Float.isNaN(menuItem.getPrice())) {
//                menuItemResponse.setPrice(0.0f);
//            }
//            if (menuItem.getQuantity() == -1) {
//                menuItemResponse.setQuantity(0);
//            }
//            if (menuItem.getImgLink() == null) {
//                menuItemResponse.setImgLink("N/A");
//            }
//            if (menuItem.getSoldQuantity() == -1) {
//                menuItemResponse.setSoldQuantity(0);
//            }
//            return menuItemResponse;
//        }).collect(Collectors.toList());
//    }
//}