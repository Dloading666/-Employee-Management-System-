package edu.com.eams.service.impl;
import edu.com.eams.domain.Attendance;
import edu.com.eams.mapper.AttendanceMapper;
import edu.com.eams.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public class AttendanceServiceImpl implements AttendanceService {
    @Autowired
    private AttendanceMapper attendanceMapper;
    public List<Attendance> getAll() { return attendanceMapper.getAll(); }
    public Attendance getById(Long id) { return attendanceMapper.getById(id); }
    public void insert(Attendance attendance) { attendanceMapper.insert(attendance); }
    public void update(Attendance attendance) { attendanceMapper.update(attendance); }
    public void delete(Long id) { attendanceMapper.delete(id); }
    public List<Attendance> getByCondition(String employeeName, Long userId, int start, int size) {
        return attendanceMapper.getByCondition(employeeName, userId, start, size);
    }
    public int countByCondition(String employeeName, Long userId) {
        return attendanceMapper.countByCondition(employeeName, userId);
    }
    @Override
    public boolean checkIn(Long userId, String userName) {
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        java.sql.Time now = new java.sql.Time(System.currentTimeMillis());
        Attendance record = attendanceMapper.getByUserAndDate(userId, today);
        if (record == null) {
            // 首次记录
            Attendance att = new Attendance();
            att.setUserId(userId);
            att.setUserName(userName);
            att.setAttendanceDate(today);
            att.setCheckInTime(now);
            att.setStatus(0);
            attendanceMapper.insert(att);
            return true;
        } else {
            if (record.getCheckInTime() != null) {
                // 已签到
                return false;
            } else {
                attendanceMapper.updateCheckInTime(record.getId(), now);
                return true;
            }
        }
    }
    @Override
    public boolean checkOut(Long userId, String userName) {
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        java.sql.Time now = new java.sql.Time(System.currentTimeMillis());
        Attendance record = attendanceMapper.getByUserAndDate(userId, today);
        if (record == null) {
            // 未签到直接签退，新增记录
            Attendance att = new Attendance();
            att.setUserId(userId);
            att.setUserName(userName);
            att.setAttendanceDate(today);
            att.setCheckOutTime(now);
            att.setStatus(0);
            attendanceMapper.insert(att);
            return true;
        } else {
            if (record.getCheckOutTime() != null) {
                return false; // 已签退
            } else {
                attendanceMapper.updateCheckOutTime(record.getId(), now);
                return true;
            }
        }
    }
} 