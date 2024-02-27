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
public class StaffResponse {
    private Integer id;

    private String email;

    private String name;

    private String password;

    private String staff_status;
    private String message;
    private boolean status;

}
