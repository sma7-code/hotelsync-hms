package com.hotelsync.hms.service;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class TokenBlacklistService {

    public static final Set<String> blacklist = ConcurrentHashMap.newKeySet();

    public void addToBlacklist(String Token){
        blacklist.add(Token);
    }

    public static boolean isBlacklisted(String Token){
        return blacklist.contains(Token);
    }
}
