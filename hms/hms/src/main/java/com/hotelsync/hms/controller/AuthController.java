package com.hotelsync.hms.controller;


import com.hotelsync.hms.dto.LoginRequest;
import com.hotelsync.hms.dto.LoginResponse;
import com.hotelsync.hms.dto.ProfileResponse;
import com.hotelsync.hms.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request){

        LoginResponse response = authService.login(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request){
        String response = authService.logout(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/profile")
    public ResponseEntity<ProfileResponse> getProfile(){
        ProfileResponse response = authService.getProfile();
        return ResponseEntity.ok(response);
    }

 }
