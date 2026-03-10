package edu.cqie.eams.mapper;
import edu.cqie.eams.domain.Attendance;
import java.util.List;
public interface AttendanceMapper {
    List<Attendance> getAll();
    Attendance getById(Long id);
    void insert(Attendance attendance);
    void update(Attendance attendance);
    void delete(Long id);
    List<Attendance> getByCondition(@org.apache.ibatis.annotations.Param("employeeName") String employeeName,
                                   @org.apache.ibatis.annotations.Param("userId") Long userId,
                                   @org.apache.ibatis.annotations.Param("start") int start,
                                   @org.apache.ibatis.annotations.Param("size") int size);
    int countByCondition(@org.apache.ibatis.annotations.Param("employeeName") String employeeName,
                         @org.apache.ibatis.annotations.Param("userId") Long userId);
    Attendance getByUserAndDate(@org.apache.ibatis.annotations.Param("userId") Long userId,
                               @org.apache.ibatis.annotations.Param("attendanceDate") java.sql.Date attendanceDate);
    void updateCheckInTime(@org.apache.ibatis.annotations.Param("id") Long id,
                           @org.apache.ibatis.annotations.Param("checkInTime") java.sql.Time checkInTime);
    void updateCheckOutTime(@org.apache.ibatis.annotations.Param("id") Long id,
                            @org.apache.ibatis.annotations.Param("checkOutTime") java.sql.Time checkOutTime);
    int deleteByUserId(@org.apache.ibatis.annotations.Param("userId") Long userId);
} 