package com.swd.ccp.models.response_models;

import jakarta.persistence.criteria.CriteriaBuilder;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShopProfileResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class ShopResponse{
        private Integer id;

        private String name;

        private String address;

        private String openTime;

        private String closeTime;

        private String phone;

        private String avatar;
    }
    private boolean status;

    private String message;

    private ShopResponse shop;
}
