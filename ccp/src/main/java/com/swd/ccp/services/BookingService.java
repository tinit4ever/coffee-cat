package com.swd.ccp.services;

import com.swd.ccp.models.request_models.CreateBookingRequest;
import com.swd.ccp.models.response_models.BookingCartResponse;

public interface BookingService {

    BookingCartResponse createBookingCart(CreateBookingRequest request);
}
