package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.AreaStatus;
import com.swd.ccp.models.entity_models.BookingDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AreaStatusRepo extends JpaRepository<AreaStatus, Integer> {
    List<AreaStatus> findAllByStatus(String status);
}