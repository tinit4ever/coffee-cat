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
public class CreateAreaRequest {

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class SeatResponse{
        private String name;

        private int capacity;
    }

    private Integer id;

    private String name;

    private List<SeatResponse> seatList;
}
