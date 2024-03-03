package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UpdateShopRequest {
    private String name;

    private String address;

    private String openTime;

    private String closeTime;

    private String phone;

    private String avatar;

}
