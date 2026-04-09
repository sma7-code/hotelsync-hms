package com.hotelsync.hms.service;


import com.hotelsync.hms.dto.*;
import com.hotelsync.hms.entity.Role;
import com.hotelsync.hms.entity.User;

import com.hotelsync.hms.exception.ResourceNotFoundException;
import com.hotelsync.hms.repository.UserRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


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

    public List<UserResponse> getAllUsers(String role) {

        List<User> users;

        if (role != null && !role.trim().isEmpty()) {

            // Role.valueOf throws IllegalArgumentException for invalid values
            // Caught by GlobalExceptionHandler.handle IllegalArgument()
            Role roleEnum = Role.valueOf(role.trim().toUpperCase());

            users = userRepository.findByRole(roleEnum);

        } else {
            users = userRepository.findAll();
        }

        return users.stream()
                .map(this::mapToResponse)
                .toList();
    }

    private UserResponse mapToResponse(User user) {

        return UserResponse.builder()
                .id(user.getId())
                .userId(user.getUserId())
                .name(user.getName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .role(user.getRole().name())
                .isActive(user.isActive())
                .isFirstLogin(user.isFirstLogin())
                .createdAt(user.getCreatedAt())
                .build();
    }

    public UserResponse getUserById(Long id){
        User user = userRepository.findById(id)
                .orElseThrow(()-> new ResourceNotFoundException("User Not Found With Id No:-"+id));
        return mapToResponse(user);
    }

    public UserResponse updateUser(Long id , UpdateUserRequest updateUserRequest){

        User user = userRepository.findById(id).orElseThrow(()->new ResourceNotFoundException("User Not Found By Id :-"+id));

        if(updateUserRequest.getEmail()!=null) {
            User existingUser = userRepository.findByEmail(updateUserRequest.getEmail()).orElse(null);


            if (existingUser != null && !existingUser.getId().equals(id)) {
                throw new RuntimeException("Email already exists");
            }
        }

        if(updateUserRequest.getName()!=null) {
            user.setName(updateUserRequest.getName());
        }

        if(updateUserRequest.getEmail()!=null) {
            user.setEmail(updateUserRequest.getEmail());
        }

        if(updateUserRequest.getPhone()!=null) {
            user.setPhone(updateUserRequest.getPhone());
        }


        User userUpdated = userRepository.save(user);

        return mapToResponse(userUpdated);

    }

    public String deactivateUser(Long id){
        User user = userRepository.findById(id)
                .orElseThrow(()-> new ResourceNotFoundException
                        ("This User Id Dont Exist On The Database"));

        if(!user.isActive()){
            throw new IllegalStateException("The User Is Already Deactivated");
        }


        user.setActive(false);
        userRepository.save(user);
        return "The User Has Been Deactivated";


    }

}