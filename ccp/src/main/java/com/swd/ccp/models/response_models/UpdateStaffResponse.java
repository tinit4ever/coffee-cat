package com.swd.ccp.models.response_models;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UpdateStaffResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class StaffResponse {
        private Integer id;

        private String email;

        private String name;

        private String phone;

        private String status;
    }

    private boolean status;

    private String message;

    private StaffResponse staffResponse;

}