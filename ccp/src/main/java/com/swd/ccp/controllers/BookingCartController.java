package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CreateBookingCartRequest;
import com.swd.ccp.models.request_models.UpdateBookingCartRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.services.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/cart")
@RequiredArgsConstructor
public class BookingCartController {

    private final BookingService bookingService;

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('customer:create')")
    public ResponseEntity<BookingCartResponse> createCart(@RequestBody CreateBookingCartRequest request){
        return ResponseEntity.ok().body(bookingService.createBookingCart(request));
    }

    @PostMapping("/update")
    @PreAuthorize("hasAuthority('customer:update')")
    public ResponseEntity<BookingCartResponse> updateCart(@RequestBody UpdateBookingCartRequest request){
        return ResponseEntity.ok().body(bookingService.updateBookingCart(request));
    }
}
