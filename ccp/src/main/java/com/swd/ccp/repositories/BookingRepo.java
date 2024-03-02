package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Booking;
import com.swd.ccp.models.entity_models.Customer;
import com.swd.ccp.models.entity_models.Seat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface BookingRepo extends JpaRepository<Booking, Integer> {

    List<Booking> findAllByCustomer(Customer customer);

    Optional<Booking> findBySeatAndBookingDate(Seat seat, Date bookingDate);

}
