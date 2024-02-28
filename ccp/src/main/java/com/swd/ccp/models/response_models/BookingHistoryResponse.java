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
public class BookingHistoryResponse {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingResponse{
        private Integer bookingID;
        private String shopName;
        private String seatName;
        private float totalPrice;
        private java.sql.Date bookingDate;
        private String status;

    }
    private boolean status;

    private String message;

    List<BookingResponse> bookingList;
}
