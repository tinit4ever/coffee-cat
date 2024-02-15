package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginResponse {

    private String message;

    private String access_token;

    private String refresh_token;

    private boolean status;

    private AccountResponse accountResponse;
}
