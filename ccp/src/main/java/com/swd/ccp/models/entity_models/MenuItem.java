package com.swd.ccp.models.entity_models;

import jakarta.persistence.*;
import lombok.*;
import net.minidev.json.annotate.JsonIgnore;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "menu_item")
public class MenuItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "menu_id")
    private Menu menu;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private MenuItemStatus menuItemStatus;

    @OneToMany(mappedBy = "menuItem")
    @ToString.Exclude
    List<BookingDetail> bookingDetailList;

    private String name;

    private float price;

    @Column(name = "img_link")
    private String imgLink;

    private String description;

    private float discount;

    @Column(name = "sold_quantity")
    private int soldQuantity;
}
