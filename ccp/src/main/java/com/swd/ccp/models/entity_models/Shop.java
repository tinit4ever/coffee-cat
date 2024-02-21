package com.swd.ccp.models.entity_models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "shop")
public class Shop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private String address;

    @Column(name = "open_time")
    private String openTime;

    @Column(name = "close_time")
    private String closeTime;

    private Double rating;

    private String phone;
    private String avatar;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private ShopStatus status;

    @ManyToOne
    @JoinColumn(name = "package_id")
    private Package packages;

    @OneToMany(mappedBy = "shop")
    private List<FollowerCustomer> followerCustomerList;

    @OneToMany(mappedBy = "shop")
    private  List<Comment> commentList;

    @OneToMany(mappedBy = "shop")
    private List<Manager> managerList;

    @OneToMany(mappedBy = "shop")
    private List<ShopImage> shopImageList;

    @OneToMany(mappedBy = "shop")
    private List<Cat> catList;

    @OneToMany(mappedBy = "shop")
    private List<Seat> seatList;
}
