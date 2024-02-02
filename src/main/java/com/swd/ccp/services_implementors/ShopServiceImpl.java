package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Comment;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.entity_models.ShopImage;
import com.swd.ccp.models.entity_models.ShopStatus;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.ShopDetailResponse;
import com.swd.ccp.models.response_models.ShopResponse;
import com.swd.ccp.repositories.FollowerCustomerRepo;
import com.swd.ccp.repositories.ShopRepo;
import com.swd.ccp.repositories.ShopStatusRepo;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {
    private final ShopStatusRepo shopStatusRepo;
    private final ShopRepo shopRepo;
    private final FollowerCustomerRepo followerCustomerRepo;
    private static final String ACTIVE = "Active";

    @Override
    public Page<ShopResponse> getActiveShops(PaginationRequest pageRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);

        if (activeStatusList.isEmpty()) {

            return Page.empty();
        }
        Pageable pageable = PageRequest.of(
                pageRequest.getPageNo(),
                pageRequest.getPageSize(),
                Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                        pageRequest.getSortByColumn())
        );

        Page<Shop> shopList = shopRepo.findAllByStatusIn(activeStatusList, pageable);

        List<ShopResponse> shopDtoList = mapToShopDtoList(shopList.getContent());

        return new PageImpl<>(shopDtoList, pageable, shopList.getTotalElements());
    }
//    @Override
//    public Page<ShopResponse> getPopularActiveShops(Integer page, Integer size) {
//        ModelMapper mapper = new ModelMapper();
//        Pageable pageable = PageRequest.of(page, size);
//        List<Shop> activeShops = shopRepo.findAllByStatus(ACTIVE, pageable).getContent();
//        List<Shop> popularActiveShops = activeShops.stream()
//                .sorted((shop1, shop2) -> Long.compare(shop2.getFollowerCustomerList().size(), shop1.getFollowerCustomerList().size()))
//                .limit(size)
//                .collect(Collectors.toList());
//        List<ShopResponse> responses = popularActiveShops.stream().map(shop -> mapper.map(shop, ShopResponse.class)).collect(Collectors.toList());
//        return new PageImpl<>(responses, pageable, activeShops.size());
//    }
    @Override
    public Page<ShopResponse> searchShops(String keyword, String searchType, PaginationRequest pageRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);

        if (activeStatusList.isEmpty()) {
            return Page.empty();
        }

        Pageable pageable = PageRequest.of(
                pageRequest.getPageNo(),
                pageRequest.getPageSize(),
                Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                        pageRequest.getSortByColumn())
        );

        Page<Shop> searchResults = shopRepo.findAllByStatusInAndNameOrAddressContaining(activeStatusList, keyword, pageable);

        List<ShopResponse> shopDtoList = mapToShopDtoList(searchResults.getContent());

        return new PageImpl<>(shopDtoList, pageable, searchResults.getTotalElements());
    }

    private List<ShopResponse> mapToShopDtoList(List<Shop> shops) {
        if (shops == null) {
            throw new IllegalArgumentException("Argument cannot be null");
        }

        if (shops.isEmpty()) {
            return Collections.emptyList();
        }

        return shops.stream().map(shop-> {
            ShopResponse shopResponse = new ShopResponse();
            shopResponse.setName(shop.getName());
            shopResponse.setRating(shop.getRating());
            List<String> imageLinks = shop.getShopImageList().stream()
                    .map(ShopImage::getLink)
                    .collect(Collectors.toList());
            shopResponse.setShopImageList(imageLinks);
            shopResponse.setFollowerCount((long) followerCustomerRepo.countByShop(shop));

            if (shop.getName() == null) {
                shopResponse.setName("N/A");
            }
            return shopResponse;
        }).collect(Collectors.toList());
    }
    @Override
    public ShopDetailResponse getShopDetails(Long id) {
        Shop shop = shopRepo.findById(id);
        if (shop != null) {
            ShopDetailResponse shopDetailResponse = ShopDetailResponse.builder()
                    .rating(shop.getRating())
                    .name(shop.getName())
                    .shopImageList(shop.getShopImageList().stream().map(ShopImage::getLink).collect(Collectors.toList()))
                    .address(shop.getAddress())
                    .openTime(shop.getOpenTime())
                    .closeTime(shop.getCloseTime())
                    .commentList(shop.getCommentList().stream().map(Comment::getComment).collect(Collectors.toList()))
                    .phone(shop.getPhone())
                    .build();
            return shopDetailResponse;
        } else {
            // Handle the case where no shop with the given id is found
            return null;
        }
    }

}