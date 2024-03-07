package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CreateShopRequest {
    private String shopName;

    private String recipientEmail;

    private String shopEmail;

    private String shopPhone;
}
