package com.swd.ccp.models.response_models;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateShopResponse {
    private Long shopId;
    private String message;
    private boolean status;
    private String token;
}
