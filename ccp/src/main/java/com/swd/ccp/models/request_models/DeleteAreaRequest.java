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
public class DeleteAreaRequest {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class SeatRequest{
        private Integer id;
    }

    private List<SeatRequest> seatList;

}
