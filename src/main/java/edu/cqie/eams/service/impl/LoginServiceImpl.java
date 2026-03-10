package edu.cqie.eams.service.impl;

import edu.cqie.eams.domain.User;
import edu.cqie.eams.mapper.UserMapper;
import edu.cqie.eams.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 登录业务实现
 */
@Service
public class LoginServiceImpl implements LoginService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String account, String password) {
        // 直接通过Mapper查询
        return userMapper.findByAccountAndPassword(account, password);
    }
} 