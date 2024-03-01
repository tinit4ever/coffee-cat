package com.swd.ccp.models.entity_models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import net.minidev.json.annotate.JsonIgnore;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "area")
public class Area {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;
    @ManyToOne
    @JoinColumn(name = "shop_id")
    private Shop shop;
    @OneToMany(mappedBy = "area")
    @JsonIgnore
    private List<Cat> catList;

    @OneToMany(mappedBy = "area")
    @JsonIgnore
    private List<Seat> seatList;
    @ManyToOne
    @JoinColumn(name = "status_id")
    private AreaStatus areaStatus;
}
