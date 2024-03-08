package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.CreateShopRequest;
import com.swd.ccp.models.request_models.SortStaffListRequest;
import com.swd.ccp.models.response_models.CreateShopResponse;
import com.swd.ccp.models.response_models.ShopListResponse;
import com.swd.ccp.models.response_models.ShopProfileResponse;
import com.swd.ccp.repositories.*;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.EmailService;
import com.swd.ccp.services.ShopOwnerService;
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
    private final ShopStatusRepo shopStatusRepo;
    private final AccountService accountService;
    private final ShopOwnerService shopOwnerService;
    private final EmailService emailService;
    private final ManagerRepo managerRepo;

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
                    if(shop.getName().toLowerCase().contains(keyword.toLowerCase())){
                        searchShopList.add(shop);
                    }
                }
                break;

            case "address":
                for(Shop shop: shopList){
                    if(shop.getAddress().toLowerCase().contains(keyword.toLowerCase())){
                        searchShopList.add(shop);
                    }
                }
                break;
        }

        return sortShops(searchShopList, request);
    }

    @Override
    public CreateShopResponse createShop(CreateShopRequest request) throws Exception {
        //---------------------------------------------------------------------------------
        //
        // concept: create a shop, start with inactive and active when all data filled
        // requirement: name, email, shopEmail, phone
        // problems:
        //      -- shop is already existed (check even in banned shop)
        //
        // steps:
        //      -- create a shop
        //      -- create an account for shop (generate password)
        //      -- create a menu
        //      -- send email
        //---------------------------------------------------------------------------------

        // check if no existed shop then continue
        if(checkIfShopNameIsExisted(request.getName()) == null){
            ShopStatus status = shopStatusRepo.findByStatus("inactive");
            // create new shop
            Shop shop = shopRepo.save(
                    Shop.builder()
                            .name(request.getName())
                            .address("")
                            .openTime("")
                            .closeTime("")
                            .rating(0.0)
                            .phone(request.getPhone())
                            .avatar("")
                            .status(status)
                            .packages(null)
                            .build()
            );

            // create shop owner account
            String randomPass = accountService.generateRandomPassword(8);
            Account account = accountService.createOwnerAccount(request, randomPass);
            if(account != null){
                shopOwnerService.createShopOwnerAccount(account, shop);

                // create a menu
                menuRepo.save(
                        Menu.builder()
                                .shop(shop)
                                .build()
                );

                // send mail
                emailService.sendOwnerAccountEmail(request.getEmail(), account.getEmail(), randomPass);
                return CreateShopResponse.builder()
                        .status(true)
                        .message("Create shop successfully")
                        .build();
            }
            return CreateShopResponse.builder()
                    .status(false)
                    .message("Shop account with email " + request.getShopEmail() + " is already existed")
                    .build();
        }
        return CreateShopResponse.builder()
                .status(false)
                .message("Shop with name " + request.getName() + " is already existed")
                .build();
    }

    @Override
    public ShopProfileResponse getShopProfile() {
        Manager owner = managerRepo.findByAccount(accountService.getCurrentLoggedUser()).orElse(null);
        assert owner != null;
        Shop shop = owner.getShop();
        return ShopProfileResponse.builder()
                .status(true)
                .message("")
                .shop(
                        ShopProfileResponse.ShopResponse.builder()
                                .id(shop.getId())
                                .name(shop.getName())
                                .address(shop.getAddress())
                                .openTime(shop.getOpenTime())
                                .closeTime(shop.getCloseTime())
                                .phone(shop.getPhone())
                                .avatar(shop.getAvatar())
                                .build()
                )
                .build();
    }

    private Shop checkIfShopNameIsExisted(String shopName){
        return shopRepo.findByName(shopName).orElse(null);
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
