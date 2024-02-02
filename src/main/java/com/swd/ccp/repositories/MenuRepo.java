package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Menu;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MenuRepo extends JpaRepository<Menu, Integer> {
}
