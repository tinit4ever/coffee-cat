package com.swd.ccp.models.entity_models;

import jakarta.persistence.*;
import lombok.*;
import net.minidev.json.annotate.JsonIgnore;

import java.sql.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "customer")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne
    @JoinColumn(name = "account_id")
    private Account account;

    private String gender;

    private Date dob;

    @OneToMany(mappedBy = "customer")
    @ToString.Exclude
    private List<FollowerCustomer> followerCustomerList;

    @OneToMany(mappedBy = "customer")
    @ToString.Exclude
    private List<Booking> bookingList;

    public void setDob(java.util.Date dob) {
        this.dob = new Date(dob.getTime());
    }
}
