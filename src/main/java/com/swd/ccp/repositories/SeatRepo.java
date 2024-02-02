package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Seat;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SeatRepo extends JpaRepository<Seat, Integer> {
}
