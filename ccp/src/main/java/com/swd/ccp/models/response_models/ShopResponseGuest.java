package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
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
    private String address;
    private List<String> commentList;
    private List<String> seatList;
    private String phone;
    private String openTime;
    private String closeTime;


}
