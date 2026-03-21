package com.hotelsync.hms.repository;

import com.hotelsync.hms.enums.ROLE;
import org.springframework.data.jpa.repository.JpaRepository;
import com.hotelsync.hms.entity.User;
import java.util.List;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {


    Optional<User> findByUserId(String user_id);

    Optional<User> findByEmail(String email);

    List<User> findByRole (ROLE role);

    List<User> findByIsActive(Boolean is_active);



}
