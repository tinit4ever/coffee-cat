package com.swd.ccp.models.entity_models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "booking")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;

    @OneToOne
    @JoinColumn(name = "seat_id")
    private Seat seat;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private BookingStatus bookingStatus;

    @Column(name = "shop_name")
    private String shopName;

    @Column(name = "seat_name")
    private String seatName;

    @Column(name = "create_date")
    private Date createDate;

    @Column(name = "booking_date")
    private Date bookingDate;

    @Column(name = "extra_content")
    private String extraContent;

    @OneToMany(mappedBy = "booking")
    private List<BookingDetail> bookingDetailList;
}
