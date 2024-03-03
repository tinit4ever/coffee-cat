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
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class StaffResponse {
        private Integer id;

        private String email;

        private String username;

        private String phone;

        private String status;
    }

    private boolean status;

    private String message;

    private StaffResponse staffResponse;
}
