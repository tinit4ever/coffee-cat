package com.swd.ccp.models.request_models;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterRequest {

    private String email;

    private String password;

    private String phone;

    private String name;

    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
    private java.sql.Date dob;

    private String gender;

    public void setDob(java.util.Date dob) {
        this.dob = new Date(dob.getTime());
    }
}
