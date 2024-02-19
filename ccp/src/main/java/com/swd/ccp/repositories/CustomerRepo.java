package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Cat;
import com.swd.ccp.models.entity_models.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CustomerRepo extends JpaRepository<Customer, Integer> {
    Optional<Customer> findById(Long customerId);
    Optional<Customer> findByAccount_Email(String email);
}
