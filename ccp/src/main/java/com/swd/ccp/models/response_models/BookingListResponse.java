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
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookingListResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class MenuItemResponse{
        private String itemName;

        @JsonSerialize(using = MenuItemListResponse.CustomFloatSerializer.class)
        private float itemPrice;

        private int quantity;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class BookingResponse{
        private Integer bookingId;

        private String shopName;

        private String seatName;

        private String areaName;

        @JsonSerialize(using = MenuItemListResponse.CustomFloatSerializer.class)
        private float totalPrice;

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
        private java.sql.Date bookingDate;

        private String status;

        private List<MenuItemResponse> itemResponseList;
    }
    private boolean status;

    private String message;

    List<BookingResponse> bookingList;

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
