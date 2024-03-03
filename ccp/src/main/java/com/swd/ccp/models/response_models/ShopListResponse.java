package com.swd.ccp.models.response_models;

import com.swd.ccp.models.entity_models.Menu;
import com.swd.ccp.models.entity_models.MenuItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShopListResponse {
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopImageResponse{
        private String link;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopCommentResponse{
        private String comment;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopMenuItemResponse{
        private Integer id;

        private String name;

        private float price;

        private String imgLink;

        private String description;

        private float discount;

        private int soldQuantity;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopResponse {
        private Integer id;

        private Double rating;

        private String name;

        private List<ShopImageResponse> shopImageList;

        private String avatar;

        private String address;

        private List<ShopCommentResponse> commentList;

        private String phone;

        private String openTime;

        private String closeTime;

        private List<ShopMenuItemResponse> menuItemList;
    }

    private List<ShopResponse> shopList;

    private boolean status;

    private String message;

}
