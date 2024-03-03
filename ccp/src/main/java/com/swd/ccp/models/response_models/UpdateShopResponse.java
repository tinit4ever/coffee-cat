package com.swd.ccp.models.response_models;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UpdateShopResponse {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class ShopResponse{
        private String name;

        private String address;

        private String openTime;

        private String closeTime;

        private String phone;

        private String avatar;
    }

    private String message;

    private boolean status;

    private ShopResponse response;

}
