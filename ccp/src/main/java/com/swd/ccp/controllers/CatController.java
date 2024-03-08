package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CreateCatRequest;
import com.swd.ccp.models.request_models.DeleteCatRequest;
import com.swd.ccp.models.response_models.CatListResponse;
import com.swd.ccp.models.response_models.CatShopListResponse;
import com.swd.ccp.models.response_models.CreateCatResponse;
import com.swd.ccp.models.response_models.DeleteCatResponse;
import com.swd.ccp.services.CatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cat")
@RequiredArgsConstructor
public class CatController {
    private final CatService catService;

    @GetMapping("/list")
    @PreAuthorize("hasAuthority('owner:read')")
    public ResponseEntity<CatShopListResponse> getCatList(){
        return ResponseEntity.ok().body(catService.getCatList());
    }

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('owner:create')")
    public ResponseEntity<CreateCatResponse> getCatList(@RequestBody CreateCatRequest request){
        return ResponseEntity.ok().body(catService.createCat(request));
    }

    @PostMapping("/delete")
    @PreAuthorize("hasAuthority('owner:delete')")
    public ResponseEntity<DeleteCatResponse> getCatList(@RequestBody DeleteCatRequest request){
        return ResponseEntity.ok().body(catService.deleteCat(request));
    }
}
