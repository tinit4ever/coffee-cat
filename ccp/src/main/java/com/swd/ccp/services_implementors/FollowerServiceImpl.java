package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Shop;
import com.swd.ccp.repositories.FollowerCustomerRepo;
import com.swd.ccp.services.FollowerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor

public class FollowerServiceImpl implements FollowerService {
    private final FollowerCustomerRepo followerCustomerRepo;
    @Override
    public Long getFollowerCountForShop(Shop shop) {
        return followerCustomerRepo.countByShop(shop);
    }
}
