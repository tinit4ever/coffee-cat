package com.swd.ccp.models.request_models;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.swd.ccp.models.entity_models.MenuItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CreateBookingRequest {
    private int seatID;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    private java.sql.Date bookingDate;

    private String extraContent;

    private HashMap<String, Integer> menuItemList;//Menu item id, quantity
}

