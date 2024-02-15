package com.swd.ccp.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public enum Permission {

    CUSTOMER_CREATE("customer:create"),
    CUSTOMER_READ("customer:read"),
    CUSTOMER_UPDATE("customer:update"),
    CUSTOMER_DELETE("customer:delete"),

    STAFF_CREATE("staff:create"),
    STAFF_READ("staff:read"),
    STAFF_UPDATE("staff:update"),
    STAFF_DELETE("staff:delete"),

    OWNER_CREATE("owner:create"),
    OWNER_READ("owner:read"),
    OWNER_UPDATE("owner:update"),
    OWNER_DELETE("owner:delete"),

    ADMIN_CREATE("admin:create"),
    ADMIN_READ("admin:read"),
    ADMIN_UPDATE("admin:update"),
    ADMIN_DELETE("admin:delete");

    @Getter
    private final String permission;
}
