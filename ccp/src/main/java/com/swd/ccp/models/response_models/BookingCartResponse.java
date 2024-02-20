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

    private boolean status;

    private String message;

    private String token;

    private List<BookingCartShopResponse> bookingCartShopResponseList;
}
