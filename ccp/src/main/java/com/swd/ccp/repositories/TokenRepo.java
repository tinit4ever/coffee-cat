package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Token;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TokenRepo extends JpaRepository<Token, Integer> {

    Optional<Token> findByAccount_IdAndStatusAndType (Integer accountId, int status, String type);

    boolean existsByToken(String token);

    Optional<Token> findByToken(String token);
}
