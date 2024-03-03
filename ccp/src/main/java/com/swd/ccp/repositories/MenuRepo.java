package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Menu;
import com.swd.ccp.models.entity_models.MenuItemStatus;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MenuRepo extends JpaRepository<Menu, Integer> {
    Optional<Menu> findByShop (Shop shop);

}
