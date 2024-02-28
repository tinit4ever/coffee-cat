package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Booking;
import com.swd.ccp.models.entity_models.BookingDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingDetailRepo extends JpaRepository<BookingDetail, Integer> {

    List<BookingDetail> findAllByBooking(Booking booking);
}
