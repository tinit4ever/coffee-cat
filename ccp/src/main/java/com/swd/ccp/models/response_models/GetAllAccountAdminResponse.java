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
public class GetAllAccountAdminResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class AccountResponse{
        private Integer id;

        private String email;

        private String name;

        private String phone;

        private String status;

        private String role;
    }

    private List<AccountResponse> accountResponseList;
}
