package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CatRepo extends JpaRepository<Cat, Integer> {
    List<Cat> findAllByCatStatusIn(List<CatStatus> catStatuses, Sort sort);
    Cat findById(Long id);
    Cat findByIdAndCatStatus(Long id, CatStatus catStatuses);
}
