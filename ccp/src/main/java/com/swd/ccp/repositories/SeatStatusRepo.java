package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Seat;
import com.swd.ccp.models.entity_models.SeatStatus;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;

public interface SeatStatusRepo extends JpaRepository<SeatStatus, Integer> {

    Collection< SeatStatus> findAllByStatus(String status);

}
