package com.swd.ccp.repositories;

import com.swd.ccp.models.entity_models.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepo extends JpaRepository<Comment, Integer> {
}
