package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChangeStatusStaffResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class StaffResponse {
        private Integer id;

        private String status;
    }

    private boolean status;

    private String message;

    private StaffResponse staffResponse;
}
