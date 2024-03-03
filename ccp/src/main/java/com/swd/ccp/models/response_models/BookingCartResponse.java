package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.text.DecimalFormat;
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
        private Integer itemId;

        private String itemName;

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "0.0")
        private double itemPrice;

        private int quantity;

    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingCartShopResponse{
        private Integer shopId;

        private String shopName;

        private Integer seatId;

        private String seatName;

        private java.sql.Date createDate;

        private java.sql.Date bookingDate;

        private String status;

        private String extraContent;

        private List<BookingCartShopMenuResponse> bookingCartShopMenuResponseList;
    }


    private boolean status;

    private String message;

    private BookingCartShopResponse bookingCartShopResponse;
}
