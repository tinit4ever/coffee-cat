package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.FollowerCustomer;
import com.swd.ccp.models.entity_models.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FollowerCustomerRepo extends JpaRepository<FollowerCustomer, Integer> {
    @Query("SELECT f.shop, COUNT(f) AS followerCount FROM FollowerCustomer f GROUP BY f.shop")
    List<Object[]> getShopFollowersCount();

    long countByShop(Shop shop);
}
