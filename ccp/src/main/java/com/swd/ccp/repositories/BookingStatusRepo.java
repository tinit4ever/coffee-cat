package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BookingStatusRepo extends JpaRepository<BookingStatus, Integer> {

    BookingStatus findByStatus(String status);
}
