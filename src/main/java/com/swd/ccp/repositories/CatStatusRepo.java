package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.CatStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CatStatusRepo extends JpaRepository<CatStatus, Integer> {
}
