package com.swd.ccp.services;

import com.swd.ccp.models.entity_models.Shop;

public interface FollowerService {
    Long getFollowerCountForShop(Shop shop);
}
