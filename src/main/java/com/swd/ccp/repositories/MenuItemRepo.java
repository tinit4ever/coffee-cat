package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MenuItemRepo extends JpaRepository<MenuItem, Integer> {
}
