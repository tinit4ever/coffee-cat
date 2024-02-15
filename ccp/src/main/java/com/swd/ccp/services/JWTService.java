package com.swd.ccp.services;

import org.springframework.security.core.userdetails.UserDetails;

public interface JWTService {

    String extractEmail(String token);

    String generateToken(UserDetails user);

    String generateRefreshToken(UserDetails user);

    boolean checkTokenIsValid(String token);
}
