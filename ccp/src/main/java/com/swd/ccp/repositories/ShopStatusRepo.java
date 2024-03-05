package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ShopStatusRepo extends JpaRepository<ShopStatus, Integer> {
    List<ShopStatus> findAllByStatus(String status);
    ShopStatus findByStatus (String status);
}
