package com.swd.ccp.models.request_models;

import lombok.*;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.Objects;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaginationRequest {
    private Integer pageNo = 0;
    private Integer pageSize = 10;
    private Sort.Direction sort = Sort.Direction.ASC;
    private String sortByColumn = "id";
    private String keyword;
    private String searchType;

    public PaginationRequest(int page, int size, String sort, String sortByColumn) {
    }

}