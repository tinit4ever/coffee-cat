package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.BookingDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookingDetailRepo extends JpaRepository<BookingDetail, Integer> {
}
