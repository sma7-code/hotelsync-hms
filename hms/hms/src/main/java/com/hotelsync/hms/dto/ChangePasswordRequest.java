package com.hotelsync.hms.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChangePasswordRequest {

    @NotBlank(message = "Your Current Password Can't Be Blank")
    private String currentPassword;

    @NotBlank(message = "The New Password is Blank Please Fill It")
    private String newPassword;

}
