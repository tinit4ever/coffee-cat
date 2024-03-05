package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.entity_models.SeatStatus;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface SeatRepo extends JpaRepository<Seat, Integer> {
    Optional<Seat> findById(long seatId);

    List<Seat> findAllByAreaAndSeatStatus(Area area, SeatStatus seatStatus);
}
