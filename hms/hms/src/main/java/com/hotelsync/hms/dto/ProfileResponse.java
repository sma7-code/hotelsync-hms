package com.hotelsync.hms.dto;


import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class ProfileResponse {

    private String userId;
    private String name;
    private String email;
    private String phone;
    private String role;


}
