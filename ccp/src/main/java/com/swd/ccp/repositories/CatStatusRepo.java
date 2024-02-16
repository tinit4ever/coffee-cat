package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CatStatusRepo extends JpaRepository<CatStatus, Integer> {
    List<CatStatus> findAllByStatus(String catStatus);
    CatStatus findByStatus (String catStatus);
}
