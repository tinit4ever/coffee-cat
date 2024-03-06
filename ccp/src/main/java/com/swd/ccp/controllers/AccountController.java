package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.ChangeAccountStatusRequest;
import com.swd.ccp.models.response_models.ChangeAccountStatusResponse;
import com.swd.ccp.models.response_models.GetAllAccountAdminResponse;
import com.swd.ccp.models.response_models.LogoutResponse;
import com.swd.ccp.models.response_models.RefreshResponse;
import com.swd.ccp.services.AccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    @GetMapping("/refresh")
    public ResponseEntity<RefreshResponse> refreshToken(){
        return ResponseEntity.ok().body(accountService.refresh());
    }

    @GetMapping("/logout")
    public ResponseEntity<LogoutResponse> logout(){
        return ResponseEntity.ok().body(accountService.logout());
    }

    @GetMapping("/get-all")
    @PreAuthorize("hasAuthority('admin:read')")
    public ResponseEntity<GetAllAccountAdminResponse> getAll(){
        return ResponseEntity.ok().body(accountService.getAllAccount());
    }

    @PostMapping("/ban")
    @PreAuthorize("hasAuthority('admin:update')")
    public ResponseEntity<ChangeAccountStatusResponse> banAccount(@RequestBody ChangeAccountStatusRequest request){
        return ResponseEntity.ok().body(accountService.changeAccountStatus(request, "ban"));
    }

    @PostMapping("/unban")
    @PreAuthorize("hasAuthority('admin:update')")
    public ResponseEntity<ChangeAccountStatusResponse> unbanAccount(@RequestBody ChangeAccountStatusRequest request){
        return ResponseEntity.ok().body(accountService.changeAccountStatus(request, "unban"));
    }
}
