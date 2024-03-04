package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.entity_models.AreaStatus;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AreaRepo extends JpaRepository<Area, Integer> {

    List<Area> findAllByShopIdAndAndAreaStatus(Integer shopId, AreaStatus areaStatus);

    Optional<Area> findByNameAndShop(String name, Shop shop);
}
