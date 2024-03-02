package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Area;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AreaRepo extends JpaRepository<Area, Integer> {

    List<Area> findByShopId(Integer shopId);
}
