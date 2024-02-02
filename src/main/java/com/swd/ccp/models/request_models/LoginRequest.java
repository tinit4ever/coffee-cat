package com.swd.ccp.models.request_models;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginRequest {
    private String email;

    private String password;
}
