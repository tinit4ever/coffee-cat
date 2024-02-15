package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.MenuItemStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemStatusRepo extends JpaRepository<MenuItemStatus, Integer> {
    List<MenuItemStatus> findAllByStatus(String menuItemStatus);
}
