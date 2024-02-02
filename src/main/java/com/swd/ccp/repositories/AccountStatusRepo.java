package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.AccountStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountStatusRepo extends JpaRepository<AccountStatus, Integer> {
}
