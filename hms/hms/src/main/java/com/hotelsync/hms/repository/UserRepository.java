package com.hotelsync.hms.repository;

import com.hotelsync.hms.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import com.hotelsync.hms.entity.User;
import java.util.List;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {


    Optional<User> findByUserId(String userId);

    Optional<User> findById(Long Id);

    Optional<User> findByEmail(String email);

    List<User> findByRole (Role role);

    List<User> findByIsActive(Boolean isActive);

    long countByRole(Role role);

   



}
