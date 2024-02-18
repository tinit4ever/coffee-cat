package com.swd.ccp.models.response_models;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class CreateShopResponse {
    private String message;
    private boolean status;

}
