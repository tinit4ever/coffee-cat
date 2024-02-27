package com.swd.ccp.controllers;

import com.swd.ccp.models.response_models.RefreshResponse;
import com.swd.ccp.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/refresh")
    public ResponseEntity<RefreshResponse> refreshToken(){
        return ResponseEntity.ok().body(userService.refresh());
    }
}
