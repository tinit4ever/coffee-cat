package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CheckMailExistedRequest;
import com.swd.ccp.models.request_models.LoginRequest;
import com.swd.ccp.models.request_models.RegisterRequest;
import com.swd.ccp.models.response_models.CheckMailExistedResponse;
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
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request){
        LoginResponse response = authenticationService.login(request);
        if(response.isStatus()){
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

    @PostMapping("/check-email")
    public ResponseEntity<CheckMailExistedResponse> checkUserIsExisted(@RequestBody CheckMailExistedRequest request){
        return ResponseEntity.ok().body(authenticationService.checkUserIsExisted(request.getEmail()));
    }

    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest request){
        RegisterResponse response = authenticationService.register(request);
        if(response.isStatus()){
            return ResponseEntity.ok().body(response);
        }
        return ResponseEntity.badRequest().body(response);
    }

}
