package com.swd.ccp.models.response_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class AccountResponse{
        private Integer id;

        private String email;

        private String name;

        private String phone;

        private String gender;

        private Integer shopId;

        private String shopName;

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
        private java.sql.Date dob;

        private String status;

        private String role;
    }


    private String message;

    private String accessToken;

    private String refreshToken;

    private boolean status;

    private AccountResponse accountResponse;
}
