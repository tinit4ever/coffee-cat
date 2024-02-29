package com.swd.ccp.controllers;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.response_models.AreaListResponse;
import com.swd.ccp.models.response_models.AreaResponse;
import com.swd.ccp.services.AreaService;
import com.swd.ccp.services.AuthenticationService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@RestController

@RequiredArgsConstructor
public class AreaController {
    private final AreaService areaService;
    @GetMapping("/auth/areas")
    public ResponseEntity<AreaListResponse> getAreasByShopAndDate(@RequestParam Integer shopId, @RequestParam String date) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date dateObj = null;
        try {
            dateObj = formatter.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        AreaListResponse areaResponseList = areaService.getAreasWithSeatsAndActiveCats(shopId, dateObj);
        return ResponseEntity.ok().body(areaResponseList);
    }
}
