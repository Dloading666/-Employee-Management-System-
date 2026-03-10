package edu.cqie.eams.service;

import edu.cqie.eams.domain.User;

public interface LoginService {
    User login(String account, String password);
} 