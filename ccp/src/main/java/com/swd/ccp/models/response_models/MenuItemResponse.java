package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.text.NumberFormat;
import java.util.Locale;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class MenuItemResponse {
    private Integer id;

    private String name;

    private Integer price;

    private String imgLink;

    private String description;

    private float discount;

    private int soldQuantity;

}
