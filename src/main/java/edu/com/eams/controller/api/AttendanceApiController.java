package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.Attendance;
import edu.com.eams.domain.User;
import edu.com.eams.security.SessionUserSupport;
import edu.com.eams.service.AttendanceService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/attendance")
public class AttendanceApiController {

    private final AttendanceService attendanceService;

    public AttendanceApiController(AttendanceService attendanceService) {
        this.attendanceService = attendanceService;
    }

    @GetMapping
    public RetJson<PageResult<Attendance>> list(
            @RequestParam(value = "employeeName", required = false) String employeeName,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            HttpSession session) {
        User currentUser = SessionUserSupport.getCurrentUser(session);
        if (currentUser == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int start = (safePageNum - 1) * safePageSize;
        Long filterUserId = SessionUserSupport.isAdmin(session) ? null : currentUser.getId();
        List<Attendance> records = attendanceService.getByCondition(employeeName, filterUserId, start, safePageSize);
        int total = attendanceService.countByCondition(employeeName, filterUserId);
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @GetMapping("/{id}")
    public RetJson<Attendance> detail(@PathVariable("id") Long id, HttpSession session) {
        Attendance attendance = attendanceService.getById(id);
        if (attendance == null) {
            return new RetJson<>(404, "Attendance record not found", null);
        }
        if (!canAccess(session, attendance)) {
            return new RetJson<>(403, "Access denied", null);
        }
        return RetJson.success(attendance);
    }

    @PostMapping
    public RetJson<Attendance> create(@RequestBody Attendance attendance, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        attendanceService.insert(attendance);
        return RetJson.success(attendance);
    }

    @PutMapping("/{id}")
    public RetJson<Attendance> update(@PathVariable("id") Long id,
                                      @RequestBody Attendance attendance,
                                      HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        attendance.setId(id);
        attendanceService.update(attendance);
        return RetJson.success(attendanceService.getById(id));
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        attendanceService.delete(id);
        return RetJson.success("Deleted");
    }

    @PostMapping("/check-in")
    public RetJson<String> checkIn(HttpSession session) {
        User currentUser = SessionUserSupport.getCurrentUser(session);
        if (currentUser == null) {
            return new RetJson<>(401, "Not logged in", null);
        }
        boolean success = attendanceService.checkIn(currentUser.getId(), currentUser.getName());
        if (!success) {
            return RetJson.error("Check-in failed");
        }
        return RetJson.success("Checked in");
    }

    @PostMapping("/check-out")
    public RetJson<String> checkOut(HttpSession session) {
        User currentUser = SessionUserSupport.getCurrentUser(session);
        if (currentUser == null) {
            return new RetJson<>(401, "Not logged in", null);
        }
        boolean success = attendanceService.checkOut(currentUser.getId(), currentUser.getName());
        if (!success) {
            return RetJson.error("Check-out failed");
        }
        return RetJson.success("Checked out");
    }

    private boolean canAccess(HttpSession session, Attendance attendance) {
        if (SessionUserSupport.isAdmin(session)) {
            return true;
        }
        User currentUser = SessionUserSupport.getCurrentUser(session);
        return currentUser != null && attendance.getUserId() != null && attendance.getUserId().equals(currentUser.getId());
    }
}
