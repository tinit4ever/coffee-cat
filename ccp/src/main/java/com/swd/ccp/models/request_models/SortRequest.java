package com.swd.ccp.models.request_models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Sort;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SortRequest {
    private boolean asc;
    private String sortByColumn ;
    private String keyword;
    private String searchType;

    public SortRequest(boolean asc, String sortByColumn) {
        this.sortByColumn = sortByColumn;
        this.asc = asc;
    }
}
