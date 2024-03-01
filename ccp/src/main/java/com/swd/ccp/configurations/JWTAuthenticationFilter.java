package com.swd.ccp.configurations;

import com.swd.ccp.models.entity_models.Account;
import com.swd.ccp.models.entity_models.Token;
import com.swd.ccp.repositories.AccountRepo;
import com.swd.ccp.repositories.TokenRepo;
import com.swd.ccp.services.JWTService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JWTAuthenticationFilter extends OncePerRequestFilter {

    private final JWTService jwtService;

    private final UserDetailsService userDetailsService;

    private final AccountRepo accountRepo;

    private final TokenRepo tokenRepo;
    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");
        String jwt;
        if(authHeader == null || !authHeader.startsWith("Bearer ")){
            filterChain.doFilter(request, response);
            return;
        }
        jwt = authHeader.substring(7);
        String accountEmail = jwtService.extractEmail(jwt);
        if(accountEmail != null && SecurityContextHolder.getContext().getAuthentication() == null){
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(accountEmail);
            Account account = accountRepo.findByEmail(userDetails.getUsername()).orElse(null);
            assert account != null;
            if(!account.getStatus().getStatus().equals("active")) {
                filterChain.doFilter(request, response);
                return;
            }
            Token refreshToken = tokenRepo.findByAccount_IdAndStatusAndType(account.getId(), 1, "refresh").orElse(null);
            assert refreshToken != null;
            //check if refresh token is expired to disable it
            if(!jwtService.checkTokenIsValid(refreshToken.getToken())){
                refreshToken.setStatus(0);
                tokenRepo.save(refreshToken);
            }

            //refresh if access token is invalid but refresh is still valid
            if(!jwtService.checkTokenIsValid(jwt)
                    && tokenRepo.findByAccount_IdAndStatusAndType(account.getId(), 1, "refresh").orElse(null) != null
            ){
                Token currentAccessToken = tokenRepo.findByToken(jwt).orElse(null);
                assert currentAccessToken != null;
                currentAccessToken.setStatus(0);
                tokenRepo.save(currentAccessToken);

                tokenRepo.save(Token.builder().token(jwtService.generateToken(account)).type("access").status(1).account(account).build());
            }
            //
            if(jwtService.checkTokenIsValid(jwt)){
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities()
                );

                authToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }
        filterChain.doFilter(request, response);
    }
}
