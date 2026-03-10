package edu.cqie.eams.service;

import edu.cqie.eams.domain.User;
import edu.cqie.eams.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private edu.cqie.eams.mapper.DepartmentMapper departmentMapper;
    @Autowired
    private edu.cqie.eams.mapper.EmployeeMapper employeeMapper;
    @Autowired
    private edu.cqie.eams.mapper.AttendanceMapper attendanceMapper;
    @Autowired
    private edu.cqie.eams.mapper.LeaveRecordMapper leaveRecordMapper;

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
        return userMapper.insert(user) > 0;
    }

    @Override
    public boolean updateUser(User user) {
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