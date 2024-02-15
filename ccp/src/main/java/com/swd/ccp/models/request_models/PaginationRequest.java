package com.swd.ccp.models.request_models;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.util.Objects;


@Getter
@Setter
public class PaginationRequest {
    private Integer pageNo = 0;
    private Integer pageSize = 10;
    private Sort.Direction sort = Sort.Direction.ASC;
    private String sortByColumn = "id";
    private String keyword;
    private String searchType;



    public Pageable getPageable() {
        Integer page = Objects.nonNull(pageNo) ? pageNo : 0;
        Integer size = Objects.nonNull(pageSize) ? pageSize : 10;

        Sort.Direction sortDirection = Objects.nonNull(sort) ? sort : Sort.Direction.ASC;
        String sortBy = Objects.nonNull(sortByColumn) ? sortByColumn : "id";
        return PageRequest.of(page, size, sortDirection, sortBy);
    }
}