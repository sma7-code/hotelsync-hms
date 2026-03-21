package com.hotelsync.hms.entity;

import com.hotelsync.hms.enums.ID_TYPE;
import jakarta.persistence.*;
import jakarta.validation.groups.Default;

@Entity
@Table
public class user {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(unique = true, nullable = false)
    private String user_id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(unique = true)
    private String phone;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private Enum<ROLE> role;





}
