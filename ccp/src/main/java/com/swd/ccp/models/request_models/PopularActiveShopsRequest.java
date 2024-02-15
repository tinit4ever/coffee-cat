package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PopularActiveShopsRequest {
    private Integer page;
    private Integer size;

    // Constructors, getters, and setters omitted for brevity
}