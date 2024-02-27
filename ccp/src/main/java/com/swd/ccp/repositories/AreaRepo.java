package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.entity_models.AreaStatus;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AreaRepo extends JpaRepository<Area, Integer> {
    List<Area> findAllByShopAndAreaStatusIn(Shop shop, List<AreaStatus> areaStatuses);

}
