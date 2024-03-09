package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DeleteCatRequest {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class CatRequest{

        private Integer catId;
    }

    private List<CatRequest> listCatId;
}
