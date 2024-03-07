package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.swd.ccp.models.entity_models.Menu;
import com.swd.ccp.models.entity_models.MenuItem;
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
public class ShopListResponse {
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopImageResponse{
        private String link;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopCommentResponse{
        private String comment;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopMenuItemResponse{
        private Integer id;

        private String name;

        @JsonSerialize(using = MenuItemListResponse.CustomFloatSerializer.class)
        private float price;

        private String imgLink;

        private String description;

        private float discount;

        private int soldQuantity;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class ShopResponse {
        private Integer id;

        private Double rating;

        private String name;

        private List<ShopImageResponse> shopImageList;

        private String avatar;

        private String address;

        private List<ShopCommentResponse> commentList;

        private String phone;

        private String openTime;

        private String closeTime;

        private List<ShopMenuItemResponse> menuItemList;
    }

    private List<ShopResponse> shopList;

    private boolean status;

    private String message;

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
