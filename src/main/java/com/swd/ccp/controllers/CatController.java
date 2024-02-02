package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.PaginationRequest;
import com.swd.ccp.models.response_models.CatResponse;
import com.swd.ccp.services.CatService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static org.hibernate.sql.ast.SqlTreeCreationLogger.LOGGER;

@RestController
@RequestMapping("/cat")
@RequiredArgsConstructor
public class CatController {
    private final CatService catService;
    @GetMapping("/list-cat")
    @PreAuthorize("hasAuthority('customer:read')")
    public Page<CatResponse> getActiveShops(@RequestParam Integer shopId, @RequestBody PaginationRequest pageRequest) {
        Page<CatResponse> page = catService.getActiveCats(shopId,pageRequest);
        LOGGER.info("get list successfully");
        return page;
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
