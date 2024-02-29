package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Area;
import com.swd.ccp.models.entity_models.AreaStatus;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.request_models.SortRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AreaRepo extends JpaRepository<Area, Integer> {

    List<Area> findByShopId(Integer shopId);
}
