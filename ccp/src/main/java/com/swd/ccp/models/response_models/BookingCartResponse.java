package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.IOException;
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

        @JsonSerialize(using = CustomFloatSerializer.class)
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

    public static class CustomFloatSerializer extends JsonSerializer<Float> {
        @Override
        public void serialize(Float value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
            if (value == Math.round(value)) {
                gen.writeNumber(value.intValue());
            } else {
                gen.writeNumber(value);
            }
        }
    }
}
