package com.swd.ccp.models.response_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CreateAreaResponse {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class SeatResponse{
        private Integer id;

        private String name;

        private int capacity;

        private String status;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class AreaResponse{
        private Integer id;

        private String name;

        private String status;

        private SeatResponse seat;
    }

    private boolean status;

    private String message;

    private AreaResponse area;
}
