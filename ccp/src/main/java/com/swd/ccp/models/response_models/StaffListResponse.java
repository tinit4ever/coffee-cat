package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StaffListResponse {

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

    private List<StaffResponse> staffList;

    private boolean status;

    private String message;
}
