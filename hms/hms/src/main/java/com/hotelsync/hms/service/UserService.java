package com.hotelsync.hms.service;


import com.hotelsync.hms.dto.*;
import com.hotelsync.hms.entity.Role;
import com.hotelsync.hms.entity.User;

import com.hotelsync.hms.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


    public UserResponse createUser(CreateUserRequest request){

    //Check For The Duplicate Email if any present

    if(userRepository.findByEmail(request.getEmail()).isPresent()){

        throw new RuntimeException("Email Has Already Link !");
    }

    // Generate userId
    String userId = generateUserId(request.getRole());

    // Create User
        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .role(request.getRole())
                .userId(userId)
                .password(passwordEncoder.encode(request.getPassword()))
                .isActive(true)
                .isFirstLogin(true)
                .build();

    User savedUser = userRepository.save(user);

    // Map to Response
    return UserResponse.builder()
            .id(savedUser.getId())
            .userId(savedUser.getUserId())
            .name(savedUser.getName())
            .email(savedUser.getEmail())
            .phone(savedUser.getPhone())
            .role(savedUser.getRole().name())
            .isActive(savedUser.isActive())
            .isFirstLogin(savedUser.isFirstLogin())
            .createdAt(savedUser.getCreatedAt())
            .build();
}

    // User id Generation Logic
    private  String generateUserId(Role role){

        // Note: potential race condition if two users created simultaneously
        // Acceptable for current single-admin usage — revisit if concurrent access needed

        long count = userRepository.countByRole(role)+1;

        String prefix = switch (role){
            case ADMIN -> "HMS-ADMIN-";
            case RECEPTIONIST -> "HMS-RECEP-";
            case MANAGER -> "HMS-MNGR-";
            case WAITER -> "HMS-WAIT-";
            case CHEF -> "HMS-CHEF-";
            case ACCOUNTANT -> "HMS-ACCT-";
        };

        return prefix + String.format("%03d",count);



    }


}