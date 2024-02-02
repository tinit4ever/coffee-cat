package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.SeatStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SeatStatusRepo extends JpaRepository<SeatStatus, Integer> {
}
