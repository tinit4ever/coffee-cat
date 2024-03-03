package com.swd.ccp.models.response_models;


import com.swd.ccp.models.entity_models.Menu;
import com.swd.ccp.models.entity_models.MenuItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShopManageResponse {
    private List<ShopResponse> shopList;

    private boolean status;

    private String message;

}
