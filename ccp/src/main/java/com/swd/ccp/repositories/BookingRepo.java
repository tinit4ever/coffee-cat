package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Booking;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookingRepo extends JpaRepository<Booking, Integer> {
}
