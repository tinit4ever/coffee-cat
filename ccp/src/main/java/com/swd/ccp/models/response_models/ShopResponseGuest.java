package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data

public class ShopResponseGuest {
    private Double rating;
    private String name;
    private List<String> shopImageList;
    private String avatar;
    private Long followerCount;
    private String message;
    private boolean status;
}
