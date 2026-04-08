package com.hotelsync.hms.dto;


import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class UserResponse {

    private Long id;
    private String userId;
    private String name;
    private String email;
    private String phone;
    private String role;
    private boolean isActive;
    private boolean isFirstLogin;
    private LocalDateTime createdAt;

}
