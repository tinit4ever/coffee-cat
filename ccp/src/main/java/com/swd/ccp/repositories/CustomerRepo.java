package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepo extends JpaRepository<Customer, Integer> {
}
