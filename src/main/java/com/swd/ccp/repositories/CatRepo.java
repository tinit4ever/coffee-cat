package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Cat;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CatRepo extends JpaRepository<Cat, Integer> {
}
