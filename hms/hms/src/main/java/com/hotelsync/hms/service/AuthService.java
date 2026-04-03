package com.hotelsync.hms.service;


import com.hotelsync.hms.config.JwtUtil;
import com.hotelsync.hms.dto.LoginRequest;
import com.hotelsync.hms.dto.LoginResponse;
import com.hotelsync.hms.dto.ProfileResponse;
import com.hotelsync.hms.entity.User;
import com.hotelsync.hms.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;




@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final TokenBlacklistService tokenBlacklistService;

    public LoginResponse login(LoginRequest loginRequest){

        //load user
        User user = userRepository.findByUserId(loginRequest.getUserId())
                .orElseThrow(()-> new BadCredentialsException("Invalid userId or Password"));


        //check active
        if(!user.isActive()){
            throw new DisabledException("Account is not active");
        }

        //check password
        if(!passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())){
            throw new BadCredentialsException("Invalid userId or Password");
        }

        // Generate Token
        String token = jwtUtil.generateToken(user);

        // Return response
        return new LoginResponse(
                token,
                user.getRole().name(),
                user.getUserId(),
                user.isFirstLogin()

        );

    }

    public String logout(HttpServletRequest request){

        String authHeader = request.getHeader("Authorization");

        if(authHeader == null || !authHeader.startsWith("Bearer ")){

            throw new RuntimeException("Token Missing");
        }

        String token = authHeader.substring(7);

        tokenBlacklistService.addToBlacklist(token);

        return "Logged out successfully ..";


    }

    public ProfileResponse getProfile(){

        // Step 1 - get user Id from JWT Token
        String userId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        // Step 2 - Fetch User From DB
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new RuntimeException("User Not Found .."));

        // Step 3 - Map to DTO

        return ProfileResponse.builder()
                .userId(user.getUserId())
                .name(user.getName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .role(user.getRole().name())
                .build();

    }



    }
