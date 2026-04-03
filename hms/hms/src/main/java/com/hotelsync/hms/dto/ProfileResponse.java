package com.hotelsync.hms.dto;


import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@Builder
public class ProfileResponse {

    private String userId;
    private String name;
    private String email;
    private String phone;
    private String role;


}
