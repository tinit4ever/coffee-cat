package com.swd.ccp.services_implementors;

import com.swd.ccp.Exception.NotFoundException;
import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.ShopRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.repositories.FollowerCustomerRepo;
import com.swd.ccp.repositories.ShopRepo;
import com.swd.ccp.repositories.ShopStatusRepo;
import com.swd.ccp.services.AccountService;
import com.swd.ccp.services.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {
    private final ShopStatusRepo shopStatusRepo;
    private final ShopRepo shopRepo;
    private final FollowerCustomerRepo followerCustomerRepo;
    private final AccountService accountService;
    private static final String ACTIVE = "opened";

    @Override
    public List<ShopResponseGuest> getActiveShops(SortRequest sortRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);
        if (activeStatusList.isEmpty()) {
            return Collections.emptyList();
        }
        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());
        List<Shop> shopList = shopRepo.findAllByStatusIn(activeStatusList, sort);
        return mapToShopDtoList(shopList);
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
    public List<ShopResponseGuest> searchShops(String keyword, String searchType, SortRequest sortRequest) {
        List<ShopStatus> activeStatusList = shopStatusRepo.findAllByStatus(ACTIVE);

        if (activeStatusList.isEmpty()) {
            return Collections.emptyList();
        }

        Sort.Direction sortDirection = sortRequest.isAsc() ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sort = Sort.by(sortDirection, sortRequest.getSortByColumn());

        List<Shop> searchResults = shopRepo.findAllByStatusInAndNameOrAddressContaining(activeStatusList, keyword, sort);

        return mapToShopDtoList(searchResults);
    }

    private List<ShopResponseGuest> mapToShopDtoList(List<Shop> shops) {
        if (shops == null) {
            throw new IllegalArgumentException("Argument cannot be null");
        }

        if (shops.isEmpty()) {
            return Collections.emptyList();
        }

        return shops.stream().map(shop-> {
            ShopResponseGuest shopResponse = new ShopResponseGuest();
            shopResponse.setName(shop.getName());
            shopResponse.setRating(shop.getRating());
            List<String> imageLinks = shop.getShopImageList().stream()
                    .map(ShopImage::getLink)
                    .collect(Collectors.toList());
            shopResponse.setShopImageList(imageLinks);
            shopResponse.setFollowerCount((long) followerCustomerRepo.countByShop(shop));
            shopResponse.setStatus(true);
            if (shop.getName() == null) {
                shopResponse.setName("N/A");
            }
            return shopResponse;
        }).collect(Collectors.toList());
    }
    @Override
    public ShopDetailResponse getShopDetails(Long id) {
        ShopStatus activeStatus = shopStatusRepo.findByStatus(ACTIVE);
        if (activeStatus == null) {
            throw new NotFoundException("Active status not found");
        }
        Shop shop = shopRepo.findByIdAndStatus(id,activeStatus);
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
                    .seatList(shop.getSeatList().stream().map(Seat::getName).collect(Collectors.toList()))
                    .status(true)
                    .build();
            return shopDetailResponse;
        } else {
            throw new NotFoundException("Shop with id " + id + " not found or is not active.");
        }
    }
    @Override
    public Page<ShopResponse> getShops(PaginationRequest pageRequest) {

        Pageable pageable = PageRequest.of(
                pageRequest.getPageNo(),
                pageRequest.getPageSize(),
                Sort.by(pageRequest.getSort().isAscending() ? Sort.Direction.ASC : Sort.Direction.DESC,
                        pageRequest.getSortByColumn())
        );

        Page<Shop> shopList = shopRepo.findAll( pageable);

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

        return shops.stream().map(shop-> {
            ShopResponse shopResponse = new ShopResponse();
            shopResponse.setName(shop.getName());
            shopResponse.setRating(shop.getRating());
            List<String> imageLinks = shop.getShopImageList().stream()
                    .map(ShopImage::getLink)
                    .collect(Collectors.toList());
            shopResponse.setShopImageList(imageLinks);
            shopResponse.setFollowerCount((long) followerCustomerRepo.countByShop(shop));
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
        if (isStringValid(request.getName()) ) {
            Shop shop = shopRepo.findByName(request.getName());

            if (shop == null) {
                shop = shopRepo.save(
                        Shop.builder()
                                .phone(request.getPhone())
                                .name(request.getName())
                                .address(request.getAddress())
                                .openTime(request.getOpenTime())
                                .closeTime(request.getCloseTime())

                                .status(shopStatusRepo.findById(1).orElse(null))
                                .build()
                );

                return CreateShopResponse.builder()
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
    private boolean isStringValid(String string) {
        return string != null && !string.isEmpty();
    }
}
