package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.LoginRequest;
import com.swd.ccp.models.request_models.RegisterRequest;
import com.swd.ccp.models.response_models.LoginResponse;
import com.swd.ccp.models.response_models.RegisterResponse;
import com.swd.ccp.services.AuthenticationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthenticationController {
//    private final ShopService shopService;
    private final AuthenticationService authenticationService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest loginRequest){
        LoginResponse response = authenticationService.login(loginRequest);
        if(response.isStatus()){
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest registerRequest){
        RegisterResponse response = authenticationService.register(registerRequest);
        if(response.isStatus()){
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

}
