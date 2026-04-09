package com.hotelsync.hms.controller;

import com.hotelsync.hms.dto.CreateUserRequest;
import com.hotelsync.hms.dto.UserResponse;
import com.hotelsync.hms.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserResponse> createUser(
            @Valid @RequestBody CreateUserRequest request) {

        UserResponse response = userService.createUser(request);

        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }



    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers(
            @RequestParam(required = false) String role ){

        List<UserResponse> users = userService.getAllUsers(role);

        return ResponseEntity.ok(users);
    }


    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id){
        UserResponse user  = userService.getUserById(id);
        return ResponseEntity.ok(user);

    }

    @GetMapping("/deactivate/{id}")
    public ResponseEntity<String> deactiveUser(@PathVariable Long id){

        String Status = userService.deactivateUser(id);

        return ResponseEntity.ok(Status);
    }

}