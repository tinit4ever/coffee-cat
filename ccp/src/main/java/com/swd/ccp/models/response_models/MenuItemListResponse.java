package com.swd.ccp.models.response_models;

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
public class MenuItemListResponse {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class MenuItemResponse {

        private Integer id;

        private String name;

        @JsonSerialize(using = CustomFloatSerializer.class)
        private float price;

        private String status;

        private String description;

        private int soldQuantity;
    }

    private boolean status;

    private String message;

    private List<MenuItemResponse> itemList;

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