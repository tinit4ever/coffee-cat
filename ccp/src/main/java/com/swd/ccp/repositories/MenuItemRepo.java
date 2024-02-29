package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemRepo extends JpaRepository<MenuItem, Integer> {
    List<MenuItem> findAllByMenuItemStatusIn(List<MenuItemStatus> menuItemStatus, Sort sort);

    List<MenuItem> findAllByMenuInAndMenuItemStatusIn(List<Menu> menu, List<MenuItemStatus> menuItemStatuses);

    List<MenuItem> findByMenu(Menu menu);
}
