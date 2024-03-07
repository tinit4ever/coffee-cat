package com.swd.ccp.controllers;

import com.swd.ccp.models.request_models.ApproveBookingRequest;
import com.swd.ccp.models.request_models.CancelBookingRequest;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.request_models.RejectBookingRequest;
import com.swd.ccp.models.response_models.*;
import com.swd.ccp.services.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/get")
    @PreAuthorize("hasAuthority('staff:read')")
    public ResponseEntity<BookingListResponse> getBookingList(){
        return ResponseEntity.ok().body(bookingService.getBookingList());
    }

    @PostMapping("/reject")
    @PreAuthorize("hasAuthority('staff:update')")
    public ResponseEntity<RejectBookingResponse> rejectBooking(@RequestBody RejectBookingRequest request){
        return ResponseEntity.ok().body(bookingService.rejectBooking(request));
    }

    @PostMapping("/approve")
    @PreAuthorize("hasAuthority('staff:update')")
    public ResponseEntity<ApproveBookingResponse> approveBooking(@RequestBody ApproveBookingRequest request){
        return ResponseEntity.ok().body(bookingService.approveBooking(request));
    }
}
