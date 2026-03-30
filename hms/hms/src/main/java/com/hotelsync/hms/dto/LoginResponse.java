package com.hotelsync.hms.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class LoginResponse {

    private String token;
    private String role;
    private String userId;
    private boolean isFirstLogin;

}
