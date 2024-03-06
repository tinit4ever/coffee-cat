package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MenuItemListResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class MenuItemResponse{
        private Integer id;

        private String name;

        private float price;

        private String status;

        private String description;

        private int soldQuantity;
    }

    private boolean status;

    private String message;

    private List<MenuItemResponse> itemList;
}
