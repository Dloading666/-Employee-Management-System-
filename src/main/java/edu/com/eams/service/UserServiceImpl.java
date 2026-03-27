package edu.com.eams.service;

import edu.com.eams.domain.User;
import edu.com.eams.mapper.UserMapper;
import edu.com.eams.security.PasswordSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private edu.com.eams.mapper.DepartmentMapper departmentMapper;
    @Autowired
    private edu.com.eams.mapper.EmployeeMapper employeeMapper;
    @Autowired
    private edu.com.eams.mapper.AttendanceMapper attendanceMapper;
    @Autowired
    private edu.com.eams.mapper.LeaveRecordMapper leaveRecordMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    @Override
    public User getUserById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    public boolean addUser(User user) {
        user.setPassword(PasswordSupport.encodeIfNecessary(passwordEncoder, user.getPassword()));
        return userMapper.insert(user) > 0;
    }

    @Override
    public boolean updateUser(User user) {
        User existing = userMapper.findById(user.getId());
        if (existing == null) {
            return false;
        }
        if (!StringUtils.hasText(user.getPassword())) {
            user.setPassword(existing.getPassword());
        } else {
            user.setPassword(PasswordSupport.encodeIfNecessary(passwordEncoder, user.getPassword()));
        }
        return userMapper.update(user) > 0;
    }

    @Override
    public boolean deleteUser(Long id) {
        attendanceMapper.deleteByUserId(id);
        leaveRecordMapper.deleteByUserId(id);
        leaveRecordMapper.clearApproveUser(id);
        departmentMapper.clearManager(id);
        employeeMapper.clearUser(id);
        return userMapper.delete(id) > 0;
    }

    @Override
    public List<User> getUsersByCondition(String name, int start, int size) {
        return userMapper.findByCondition(name, start, size);
    }

    @Override
    public int countUsersByCondition(String name) {
        return userMapper.countByCondition(name);
    }
}
