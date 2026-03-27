package edu.com.eams.service.impl;

import edu.com.eams.domain.User;
import edu.com.eams.mapper.UserMapper;
import edu.com.eams.security.PasswordSupport;
import edu.com.eams.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class LoginServiceImpl implements LoginService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public User login(String account, String password) {
        User user = userMapper.findByAccount(account);
        if (user == null) {
            return null;
        }
        return PasswordSupport.matches(passwordEncoder, password, user.getPassword()) ? user : null;
    }
}
