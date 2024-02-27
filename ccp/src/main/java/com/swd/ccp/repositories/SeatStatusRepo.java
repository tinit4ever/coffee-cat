package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.SeatStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SeatStatusRepo extends JpaRepository<SeatStatus, Integer> {

    Optional<SeatStatus> findByStatus(String status);
}
