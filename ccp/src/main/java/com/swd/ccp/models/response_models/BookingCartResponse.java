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
public class BookingCartResponse {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingCartShopMenuResponse{
        private Integer itemID;

        private String itemName;

        private float itemPrice;

        private int quantity;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingCartShopResponse{
        private Integer shopID;

        private String shopName;

        private Integer seatID;

        private String seatName;

        private java.sql.Date createDate;

        private java.sql.Date bookingDate;

        private String status;

        private String extraContent;

        private List<BookingCartShopMenuResponse> bookingCartShopMenuResponseList;
    }


    private boolean status;

    private String message;

    private String token;

    private BookingCartShopResponse bookingCartShopResponse;
}
