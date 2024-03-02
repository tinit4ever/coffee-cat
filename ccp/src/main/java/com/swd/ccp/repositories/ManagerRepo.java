package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Manager;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ManagerRepo extends JpaRepository<Manager, Integer> {

    Optional<Manager> findByAccount(Account account);
}
