package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.ShopListResponse;
import com.swd.ccp.repositories.MenuRepo;
import com.swd.ccp.repositories.ShopRepo;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {
    private final ShopRepo shopRepo;
    private final MenuRepo menuRepo;

    @Override
    public ShopListResponse getActiveShops(SortStaffListRequest request) {
        List<Shop> shopList = shopRepo.findAll();

        return sortShops(shopList, request);
    }

    @Override
    public ShopListResponse searchShops(String keyword, String searchType, SortStaffListRequest request) {
        List<Shop> shopList = shopRepo.findAll();
        List<Shop> searchShopList = new ArrayList<>();
        switch (searchType){
            case "name":
                for(Shop shop: shopList){
                    if(shop.getName().contains(keyword)){
                        searchShopList.add(shop);
                    }
                }
                break;

            case "address":
                for(Shop shop: shopList){
                    if(shop.getAddress().contains(keyword)){
                        searchShopList.add(shop);
                    }
                }
                break;
        }

        return sortShops(searchShopList, request);
    }

    private ShopListResponse sortShops(List<Shop> shopList, SortStaffListRequest request) {
        List<ShopListResponse.ShopResponse> shopResponseList = new ArrayList<>();

        List<ShopListResponse.ShopImageResponse> imageList = new ArrayList<>();
        List<ShopListResponse.ShopCommentResponse> commentList = new ArrayList<>();
        List<ShopListResponse.ShopMenuItemResponse> itemList = new ArrayList<>();

        for(Shop shop: shopList){
            if(shop.getStatus().getStatus().equals("active")){
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
}
