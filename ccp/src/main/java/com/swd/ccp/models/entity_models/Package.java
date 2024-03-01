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
@Table(name = "package")
public class Package {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private Integer duration; //count in number of day

    @Column(name = "purchase_date")
    private Date purchaseDate;

    @OneToMany(mappedBy = "packages")
    @ToString.Exclude
    private List<Shop> shopList;

    @ManyToOne
    @JoinColumn(name = "status_id")
    private PackageStatus status;

    public void setPurchaseDate(java.util.Date purchaseDate) {
        this.purchaseDate = new Date(purchaseDate.getTime());
    }
}
