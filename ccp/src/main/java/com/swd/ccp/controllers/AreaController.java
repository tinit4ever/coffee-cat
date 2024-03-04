package com.swd.ccp.controllers;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.request_models.GetAreaListRequest;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;
import com.swd.ccp.services.AreaService;
import com.swd.ccp.services.AuthenticationService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class AreaController {
    private final AreaService areaService;
    @PostMapping("/auth/areas")
    public ResponseEntity<AreaListResponse> getAreasByShopAndDate(@RequestBody GetAreaListRequest request) {
        AreaListResponse areaResponseList = areaService.getAreasWithSeatsAndActiveCats(request);
        return ResponseEntity.ok().body(areaResponseList);
    }
}
