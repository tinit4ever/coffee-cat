package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookingStatusRepo extends JpaRepository<BookingStatus, Integer> {
}
