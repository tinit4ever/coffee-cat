package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.CatStatus;
import com.swd.ccp.models.entity_models.MenuItem;
import com.swd.ccp.models.entity_models.MenuItemStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemRepo extends JpaRepository<MenuItem, Integer> {
    List<MenuItem> findAllByMenuItemStatusIn(List<MenuItemStatus> menuItemStatus, Sort sort);

}
