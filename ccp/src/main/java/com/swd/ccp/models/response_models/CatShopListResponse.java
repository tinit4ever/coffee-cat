package com.swd.ccp.models.response_models;

import com.swd.ccp.models.entity_models.Area;
import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CatShopListResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class CatResponse{
        private Integer id;

        private String name;

        private Integer areaId;

        private String areaName;

        private String type;

        private String description;

        private String imgLink;
    }

    private boolean status;

    private String message;

    private List<CatResponse> cat;
}
