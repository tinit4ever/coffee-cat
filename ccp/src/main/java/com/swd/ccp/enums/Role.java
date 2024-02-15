package com.swd.ccp.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.List;
import java.util.Set;

import static com.swd.ccp.enums.Permission.*;


@RequiredArgsConstructor
public enum Role {
    CUSTOMER(
            Set.of(
                    CUSTOMER_CREATE,
                    CUSTOMER_READ,
                    CUSTOMER_UPDATE,
                    CUSTOMER_DELETE
            )
    ),
    STAFF(
            Set.of(
                    STAFF_CREATE,
                    STAFF_READ,
                    STAFF_UPDATE,
                    STAFF_DELETE
            )
    ),
    OWNER(
            Set.of(
                    STAFF_CREATE,
                    STAFF_READ,
                    STAFF_UPDATE,
                    STAFF_DELETE,

                    OWNER_CREATE,
                    OWNER_READ,
                    OWNER_UPDATE,
                    OWNER_DELETE
            )
    ),
    ADMIN(
            Set.of(
                    ADMIN_CREATE,
                    ADMIN_READ,
                    ADMIN_UPDATE,
                    ADMIN_DELETE
            )
    );

    @Getter
    private final Set<Permission> permissions;

    public List<SimpleGrantedAuthority> getAuthorities(){
        var author = new java.util.ArrayList<>(getPermissions()
                .stream()
                .map(permission -> new SimpleGrantedAuthority(permission.getPermission()))
                .toList());

        author.add(new SimpleGrantedAuthority("ROLE_" + this.name()));
        return author;
    }
}
