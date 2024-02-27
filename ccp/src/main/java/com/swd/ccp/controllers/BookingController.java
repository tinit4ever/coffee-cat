package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.CancelBookingRequest;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.response_models.CancelBookingResponse;
import com.swd.ccp.models.response_models.CreateBookingResponse;
import com.swd.ccp.services.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/booking")
@RequiredArgsConstructor
public class BookingController {

    final BookingService bookingService;

    @PostMapping("/create")
    @PreAuthorize("hasAuthority('customer:create')")
    public ResponseEntity<CreateBookingResponse> createBooking(@RequestBody CreateBookingRequest request){
        return ResponseEntity.ok().body(bookingService.createBooking(request));
    }

    @PostMapping("/cancel")
    @PreAuthorize("hasAuthority('customer:delete')")
    public ResponseEntity<CancelBookingResponse> cancelBooking(@RequestBody CancelBookingRequest request){
        return ResponseEntity.ok().body(bookingService.cancelBooking(request));
    }
}
