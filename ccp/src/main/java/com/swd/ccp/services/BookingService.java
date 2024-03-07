package com.swd.ccp.services;

import com.swd.ccp.models.request_models.*;
import com.swd.ccp.models.response_models.*;

public interface BookingService {

    BookingCartResponse createBookingCart(CreateBookingCartRequest request);

    BookingCartResponse updateBookingCart(UpdateBookingCartRequest request);

    CreateBookingResponse createBooking(CreateBookingRequest request);

    CancelBookingResponse cancelBooking(CancelBookingRequest request);

    BookingListResponse getBookingList();

    RejectBookingResponse rejectBooking(RejectBookingRequest request);

    ApproveBookingResponse approveBooking(ApproveBookingRequest request);
}
