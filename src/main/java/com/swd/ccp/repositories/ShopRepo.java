package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ShopRepo extends JpaRepository<Shop, Integer> {
    Page<Shop> findAllByStatus(String status, Pageable pageable);
    Page<Shop> findAllByStatusIn(List<ShopStatus> status, Pageable pageable);
    @Query("SELECT s FROM Shop s WHERE s.status IN :status AND " +
            "(LOWER(s.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(s.address) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Shop> findAllByStatusInAndNameOrAddressContaining(List<ShopStatus> status, String keyword, Pageable pageable);
    Shop findById(Long id);
//    Page<Shop> findAllByStatusOrderByNameAsc(ShopStatus status, Pageable pageable);
//    @Query("SELECT COUNT(s) FROM Shop s JOIN s.followerCustomerList fc WHERE fc.id = :customerId")
//    Long countOccurrenceOfFollowerCustomer(@Param("customerId") Long customerId);
}
