package com.hotelsync.hms.entity;

import com.hotelsync.hms.enums.ID_TYPE;
import com.hotelsync.hms.enums.ROLE;
import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

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
    private ROLE role;

    @Column(nullable = false)
    public boolean is_first_login;

    @Column(nullable = false)
    public boolean is_active;

    @Column(nullable = false)
    public Timestamp created_at;

}
