package com.swd.ccp.services_implementors;

import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.JWTService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class JWTServiceImpl implements JWTService {

    @Value("f5aa9f96034f1b8baab27eab35a7b76cf7120f8330be3e257d6104fc9ba4ce0e")
    private String secretKey;

    @Value("10800000") // 3 hours
    private long accessTokenExpiration;

    @Value("432000000") // 5 days
    private long refreshTokenExpiration;

    private final TokenRepo tokenRepo;

    @Override
    public String extractEmail(String token) {
        return extractRequiredClaim(token, Claims::getSubject);
    }

    @Override
    public String generateToken(UserDetails user) {
        return generateToken(new HashMap<>(), user, accessTokenExpiration);
    }

    @Override
    public String generateRefreshToken(UserDetails user) {
        return generateToken(new HashMap<>(), user, refreshTokenExpiration);
    }

    @Override
    public boolean checkTokenIsValid(String token) {
        Token t = tokenRepo.findByToken(token).orElse(null);
        if(t == null) return false;
        if(t.getStatus() == 0) return false;
        return !extractRequiredClaim(token, Claims::getExpiration).before(new Date());
    }

    private <T> T extractRequiredClaim(String token, Function<Claims, T> claimsResolver){
        return claimsResolver.apply(extractAllClaims(token));
    }

    private Claims extractAllClaims(String token){
        return Jwts
                .parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(Decoders.BASE64URL.decode(secretKey));
    }

    private String generateToken(Map<String, Object> extraClaims, UserDetails userDetails, long expirationTime){
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(getSigningKey())
                .compact();
    }

}
