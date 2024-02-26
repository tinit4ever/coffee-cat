package com.swd.ccp.services;

import com.swd.ccp.models.request_models.CreateBookingCartRequest;
import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.request_models.UpdateBookingCartRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;
import com.swd.ccp.models.response_models.CreateBookingResponse;

public interface BookingService {

    BookingCartResponse createBookingCart(CreateBookingCartRequest request);

    BookingCartResponse updateBookingCart(UpdateBookingCartRequest request);

    CreateBookingResponse createBooking(CreateBookingRequest request);
}
