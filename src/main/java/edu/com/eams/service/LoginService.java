package edu.com.eams.service;

import edu.com.eams.domain.User;

public interface LoginService {
    User login(String account, String password);
} 