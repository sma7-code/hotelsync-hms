package com.hotelsync.hms.service;


import com.hotelsync.hms.config.JwtUtil;
import com.hotelsync.hms.dto.LoginRequest;
import com.hotelsync.hms.dto.LoginResponse;
import com.hotelsync.hms.entity.User;
import com.hotelsync.hms.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

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



    }
