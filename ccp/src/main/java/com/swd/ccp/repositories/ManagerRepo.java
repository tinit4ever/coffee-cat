package com.swd.ccp.repositories;

import com.swd.ccp.enums.Role;
import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Manager;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ManagerRepo extends JpaRepository<Manager, Integer> {
    @Query("SELECT m.account FROM Manager m WHERE m.shop.id = :shopId AND m.account.role = :role")
    List<Account> findStaffByShopIdAndRole(@Param("shopId") Integer shopId, @Param("role") Role role, Sort sort);
}
