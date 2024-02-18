package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.models.entity_models.ShopStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ShopRepo extends JpaRepository<Shop, Integer> {
    Page<Shop> findAll (Pageable pageable);
    Page<Shop> findAllByStatusIn(List<ShopStatus> status, Pageable pageable);
    @Query("SELECT s FROM Shop s WHERE s.status IN :status AND " +
            "(LOWER(s.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(s.address) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Shop> findAllByStatusInAndNameOrAddressContaining(List<ShopStatus> status, String keyword, Pageable pageable);
    Shop findByIdAndStatus(Long id,ShopStatus status);
    Shop findByName(String name);
    Optional<Shop> findById(long shopId);
}
