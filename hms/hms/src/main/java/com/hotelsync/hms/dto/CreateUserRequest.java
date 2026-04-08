package com.hotelsync.hms.dto;

import com.hotelsync.hms.entity.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateUserRequest {

    @NotBlank
    private String name;

    @NotBlank(message = "Email Can't Be Blank")
    @Email(message = "Please Enter The Correct Email")
    private String email;

    private String phone;

    @NotNull
    private Role role;

    @NotBlank
    private String password;




    }
