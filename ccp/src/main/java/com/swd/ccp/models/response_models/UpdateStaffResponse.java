package com.swd.ccp.models.response_models;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateStaffResponse {
    private Integer staffId;
    private String message;
    private boolean success;

}