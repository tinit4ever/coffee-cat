package com.swd.ccp.models.request_models;

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
public class CreateBookingRequest {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingShopMenuRequest{
        private Integer itemId;

        private int quantity;
    }

    private Integer seatId;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private java.sql.Date bookingDate;

    private String extraContent;

    private List<BookingShopMenuRequest> bookingShopMenuRequestList;
}
