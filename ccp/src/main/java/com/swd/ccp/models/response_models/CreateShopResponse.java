package com.swd.ccp.models.response_models;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class CreateShopResponse {
    private boolean status;

    private String message;
}
