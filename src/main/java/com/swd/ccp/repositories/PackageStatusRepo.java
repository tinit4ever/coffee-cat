package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.PackageStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PackageStatusRepo extends JpaRepository<PackageStatus, Integer> {
}
