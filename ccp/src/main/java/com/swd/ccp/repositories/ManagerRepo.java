package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Manager;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ManagerRepo extends JpaRepository<Manager, Integer> {
}
