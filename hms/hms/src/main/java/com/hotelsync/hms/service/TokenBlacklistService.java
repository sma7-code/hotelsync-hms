package com.hotelsync.hms.service;

import org.hibernate.annotations.SecondaryRow;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class TokenBlacklistService {

    public static final Set<String> blacklist = ConcurrentHashMap.newKeySet();

    public void addToBlacklist(String token){
        blacklist.add(token);
    }

    public static boolean isBlacklisted(String token){

        return blacklist.contains(token);
    }
}
