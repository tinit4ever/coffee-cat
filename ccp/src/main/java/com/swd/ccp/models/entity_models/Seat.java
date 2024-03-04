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
@Table(name = "seat")
public class Seat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "area_id")
    private Area area;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private SeatStatus seatStatus;

    @OneToMany(mappedBy = "seat")
    @ToString.Exclude
    List<Booking> bookingList;

    private String name;

    private int capacity;
//
//    @Transient
//    private boolean isAvailable;
}
