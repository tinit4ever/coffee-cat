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
public class BookingCartShopResponse {
    private String shopName;

    private String seatName;

    private java.sql.Date createDate;

    private java.sql.Date bookingDate;

    private String status;

    private String extraContent;

    private List<BookingCartShopMenuResponse> bookingCartShopMenuResponseList;
}
