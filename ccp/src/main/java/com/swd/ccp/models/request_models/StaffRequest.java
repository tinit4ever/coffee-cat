package com.swd.ccp.models.request_models;

import com.swd.ccp.models.entity_models.AccountStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StaffRequest {
        private Integer shopId;

        private String email;

        private String password;

        private String name;
    }
