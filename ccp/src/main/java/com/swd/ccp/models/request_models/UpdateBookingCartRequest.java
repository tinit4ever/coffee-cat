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
public class UpdateBookingCartRequest {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingCartShopMenuRequest{
        private Integer itemId;

        private int quantity;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingCartShopRequest{
        private Integer seatId;

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
        private java.sql.Date bookingDate;

        private String extraContent;

        private List<BookingCartShopMenuRequest> list;
    }

    private BookingCartShopRequest oldCart;

    private BookingCartShopRequest newCart;


}
