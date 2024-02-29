package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
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
        private String areaName;
        private float totalPrice;
        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
        private java.sql.Date bookingDate;
        private String status;

    }
    private boolean status;

    private String message;

    List<BookingResponse> bookingList;
}
