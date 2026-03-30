package com.hotelsync.hms.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {

    @NotBlank(message = "user id is required")
    private String userId;

    @NotBlank(message = "Password is required")
    private String password;
}
