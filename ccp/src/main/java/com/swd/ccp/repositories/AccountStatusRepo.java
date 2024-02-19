package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.AccountStatus;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountStatusRepo extends JpaRepository<AccountStatus, Integer> {
    AccountStatus findByStatus (String status);

}
