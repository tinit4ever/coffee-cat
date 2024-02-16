package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class CreateStaffResponse {


    private boolean status;

    private String message;

    private String access_token;

    private String refresh_token;

    private StaffResponse staffResponse;
}
