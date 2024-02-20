package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.request_models.SortRequest;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.models.response_models.MenuItemResponse;
import com.swd.ccp.services.CatService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequestMapping("/cat")
@RequiredArgsConstructor
public class CatController {
    private final CatService catService;
    @GetMapping("/list-cat")
    @PreAuthorize("hasAuthority('customer:read')")
    public ResponseEntity<List<CatResponse>> getActiveCats(@RequestParam(value = "sortByColumn", defaultValue = "name") String sortByColumn,
                                                                 @RequestParam(value = "asc", defaultValue = "true") boolean ascending,
                                                                 @RequestParam Integer shopId) {
        SortRequest sortRequest = new SortRequest(ascending, sortByColumn);
        List<CatResponse> activeCats = catService.getActiveCats(shopId,sortRequest);
        return ResponseEntity.ok(activeCats);
    }
    @GetMapping("/cats/{id}")
    @PreAuthorize("hasAuthority('customer:read')")
    public ResponseEntity<CatResponse> getCatDetails(@PathVariable Long id) {
        CatResponse catResponse = catService.getCatDetails(id);
        if (catResponse != null) {
            return ResponseEntity.ok(catResponse );
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
