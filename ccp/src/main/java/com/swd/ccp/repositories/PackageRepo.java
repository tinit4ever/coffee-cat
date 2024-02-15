package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Package;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PackageRepo extends JpaRepository<Package, Integer> {
}
