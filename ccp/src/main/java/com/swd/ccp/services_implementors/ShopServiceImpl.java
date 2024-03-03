package com.swd.ccp.services_implementors;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
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

    @Override
    public ShopListResponse getActiveShops(SortStaffListRequest request) {
        List<Shop> shopList = shopRepo.findAll();
        List<ShopListResponse.ShopResponse> shopResponseList = new ArrayList<>();

        List<ShopListResponse.ShopImageResponse> imageList = new ArrayList<>();
        List<ShopListResponse.ShopCommentResponse> commentList = new ArrayList<>();
        List<ShopListResponse.ShopMenuItemResponse> itemList = new ArrayList<>();

        for(Shop shop: shopList){
            for(ShopImage image: shop.getShopImageList()){
                imageList.add(ShopListResponse.ShopImageResponse.builder().link(image.getLink()).build());
            }

            for(Comment comment: shop.getCommentList()){
                commentList.add(ShopListResponse.ShopCommentResponse.builder().comment(comment.getComment()).build());
            }

            Menu menu = menuRepo.findByShop(shop).orElse(null);
            assert menu != null;
            for(MenuItem item: menu.getMenuItemList()){
                itemList.add(
                        ShopListResponse.ShopMenuItemResponse.builder()
                                .id(item.getId())
                                .name(item.getName())
                                .price(item.getPrice())
                                .imgLink(item.getImgLink())
                                .description(item.getDescription())
                                .discount(item.getDiscount())
                                .soldQuantity(item.getSoldQuantity())
                                .build()
                );
            }
            if(shop.getStatus().getStatus().equals("active")){
                shopResponseList.add(
                        ShopListResponse.ShopResponse.builder()
                                .id(shop.getId())
                                .rating(shop.getRating())
                                .name(shop.getName())
                                .shopImageList(imageList)
                                .avatar(shop.getAvatar())
                                .address(shop.getAddress())
                                .commentList(commentList)
                                .phone(shop.getPhone())
                                .openTime(shop.getOpenTime())
                                .closeTime(shop.getCloseTime())
                                .menuItemList(itemList)
                                .build()
                );
            }
        }

        // sort
        if(request.isAscOrder()){
            sortAsc(shopResponseList, request.getColumn());
        }else {
            sortDesc(shopResponseList, request.getColumn());
        }

        return ShopListResponse.builder()
                .status(true)
                .message("")
                .shopList(shopResponseList)
                .build();
    }

    private void sortAsc(List<ShopListResponse.ShopResponse> shopResponseList, String column){
        switch (column){
            case "id":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getId));
                break;
            case "name":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getName));
                break;
            case "rating":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getRating));
                break;
            case "address":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getAddress));
                break;
        }
    }

    private void sortDesc(List<ShopListResponse.ShopResponse> shopResponseList, String column){
        switch (column){
            case "id":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getId).reversed());
                break;
            case "name":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getName).reversed());
                break;
            case "rating":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getRating).reversed());
                break;
            case "address":
                shopResponseList.sort(Comparator.comparing(ShopListResponse.ShopResponse::getAddress).reversed());
                break;
        }
    }

    @Override
    public ShopListResponse searchShops(String keyword, String searchType, SortStaffListRequest sortStaffListRequest) {
        return null;
    }
}
