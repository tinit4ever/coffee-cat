package com.swd.ccp.models.request_models;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.entity_models.Package;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

import java.util.List;

public class ShopRequest {
    private String name;

    private String address;

    private String openTime;

    private String closeTime;

    private Integer rating;

    private String phone;

    private ShopStatus status;

    private List<ShopImage> shopImageList;

    private List<Seat> seatList;
}
