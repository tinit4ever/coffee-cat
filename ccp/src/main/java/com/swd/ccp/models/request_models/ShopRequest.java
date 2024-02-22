package com.swd.ccp.models.request_models;

import com.swd.ccp.models.entity_models.*;
import com.swd.ccp.models.entity_models.Package;
import jakarta.persistence.Column;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShopRequest {
    private String name;

    private String address;

    private String openTime;
    private List<ShopImage> shopImageList;
    private String closeTime;
    private Seat seat;
    private String avatar;
    private String phone;
    private ShopStatus shopStatus;
    private List<Seat> seatList;
}
