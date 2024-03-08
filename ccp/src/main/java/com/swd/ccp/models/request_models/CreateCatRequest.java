package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CreateCatRequest {
    private String name;

    private String areaName;

    private String type;

    private String description;

    private String imgLink;
}
