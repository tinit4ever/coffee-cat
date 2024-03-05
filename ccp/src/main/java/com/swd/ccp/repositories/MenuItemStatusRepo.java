package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.entity_models.MenuItemStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MenuItemStatusRepo extends JpaRepository<MenuItemStatus, Integer> {
    List<MenuItemStatus> findAllByStatus(String menuItemStatus);

    MenuItemStatus findByStatus(String status);
}
