package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterResponse {
    private boolean status;

    private String message;

    private String accessToken;

    private String refreshToken;

    private AccountResponse accountResponse;
}
