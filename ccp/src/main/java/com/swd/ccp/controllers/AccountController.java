package com.swd.ccp.controllers;

import com.swd.ccp.models.response_models.LogoutResponse;
import com.swd.ccp.services.AccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    @GetMapping("/logout")
    public ResponseEntity<LogoutResponse> logout(){
        return ResponseEntity.ok().body(accountService.logout());
    }
}
