package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SeatRepo extends JpaRepository<Seat, Integer> {
    Optional<Seat> findById(long seatId);
}
