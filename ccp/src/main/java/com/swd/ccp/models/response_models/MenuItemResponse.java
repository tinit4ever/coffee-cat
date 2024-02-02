package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class MenuItemResponse {


    private String name;

    private float price;

    private String imgLink;

    private String description;

    private float discount;

    private int quantity;

    private int soldQuantity;
    private boolean success;
    private String token;
}
