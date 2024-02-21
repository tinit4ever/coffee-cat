package com.swd.ccp.models.request_models;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.swd.ccp.models.entity_models.MenuItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
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
    public static class MenuItemRequest {
        private int itemID;

        private int quantity;
    }

    private int seatID;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private java.sql.Date bookingDate;

    private String extraContent;

    private List<MenuItemRequest> menuItemList;
}

