package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CatRepo extends JpaRepository<Cat, Integer> {
    Page<Cat> findAllByCatStatusIn(List<CatStatus> catStatuses, Pageable pageable);
    Cat findById(Long id);
}
