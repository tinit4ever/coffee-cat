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
import java.text.NumberFormat;
import java.util.Locale;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class MenuItemResponse {
    private Integer id;

    private String name;

    @JsonSerialize(using = MenuItemListResponse.CustomFloatSerializer.class)
    private Integer price;

    private String imgLink;

    private String description;

    private float discount;

    private int soldQuantity;

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
