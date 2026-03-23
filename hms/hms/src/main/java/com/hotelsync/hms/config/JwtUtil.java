package com.hotelsync.hms.config;

import java.security.Key;
import io.jsonwebtoken.security.Keys;

public class JwtUtil{

    private final String SECRET = "mysecretkeymysecretkeymysecretkey";

    private final long EXPIRATION = 1000*60*60*10;


    private Key getSignKey() {
        return Keys.hmacShaKeyFor(SECRET.getBytes());
    }






}
