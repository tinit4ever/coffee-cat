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
public class ShopDetailResponse {
    private Integer rating;
    private String name;
    private List<String> shopImageList;
    private String address;
    private String openTime;
    private String closeTime;
    private String phone;
    private List<String> commentList;

}
