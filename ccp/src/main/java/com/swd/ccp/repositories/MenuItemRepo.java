package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MenuItemRepo extends JpaRepository<MenuItem, Integer> {
    List<MenuItem> findByMenu(Menu menu);

    boolean existsByNameAndMenu(String name, Menu menu);

    Optional<MenuItem> findByIdAndMenu(Integer id, Menu menu);
}
