package com.swd.ccp.repositories;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepo extends JpaRepository<Account, Integer> {

    Optional<Account> findByEmail(String email);
    Page<Account> findByRole(Role role, Pageable pageable);
    Optional<Account> findById(Long id);

}
