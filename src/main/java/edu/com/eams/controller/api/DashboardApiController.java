package edu.com.eams.controller.api;

import edu.com.eams.comm.RetJson;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardApiController {

    private final JdbcTemplate jdbcTemplate;

    public DashboardApiController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/summary")
    public RetJson<Map<String, Object>> summary() {
        try {
            Map<String, Object> data = new HashMap<>();
            data.put("userCount", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM sys_user", Long.class));
            data.put("employeeCount", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM emp", Long.class));
            data.put("departmentCount", jdbcTemplate.queryForObject("SELECT COUNT(*) FROM sys_dept", Long.class));
            data.put("todayAttendance",
                    jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM emp_attendance_record WHERE attendance_date = CURRENT_DATE",
                            Long.class
                    ));
            return RetJson.success(data);
        } catch (Exception e) {
            return RetJson.error("Failed to load summary: " + e.getMessage());
        }
    }

    @GetMapping("/dept-employee")
    public RetJson<List<Map<String, Object>>> deptEmployee() {
        try {
            List<Map<String, Object>> list = jdbcTemplate.query(
                    "SELECT d.name AS name, COUNT(e.id) AS value FROM sys_dept d LEFT JOIN emp e ON e.dept_id = d.id GROUP BY d.name",
                    (rs, i) -> {
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", rs.getString("name"));
                        item.put("value", rs.getLong("value"));
                        return item;
                    }
            );
            return RetJson.success(list);
        } catch (Exception e) {
            return RetJson.error("Failed to load department stats: " + e.getMessage());
        }
    }

    @GetMapping("/attendance-status")
    public RetJson<List<Map<String, Object>>> attendanceStatus() {
        try {
            List<Map<String, Object>> list = jdbcTemplate.query(
                    "SELECT status, COUNT(*) AS cnt FROM emp_attendance_record WHERE attendance_date = CURRENT_DATE GROUP BY status",
                    (rs, i) -> {
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", switch (rs.getInt("status")) {
                            case 0 -> "Normal";
                            case 1 -> "Late";
                            case 2 -> "Early Leave";
                            case 3 -> "Absent";
                            default -> "Unknown";
                        });
                        item.put("value", rs.getLong("cnt"));
                        return item;
                    }
            );
            return RetJson.success(list);
        } catch (Exception e) {
            return RetJson.error("Failed to load attendance stats: " + e.getMessage());
        }
    }

    @GetMapping("/add-leave-trend")
    public RetJson<Map<String, Object>> addLeaveTrend() {
        try {
            String addSql = "SELECT DATE_FORMAT(entry_date,'%Y-%m') ym, COUNT(*) cnt FROM emp " +
                    "WHERE entry_date >= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 5 MONTH),'%Y-%m-01') " +
                    "GROUP BY ym ORDER BY ym";
            String leaveSql = "SELECT DATE_FORMAT(create_time,'%Y-%m') ym, COUNT(*) cnt FROM emp_leave_record " +
                    "WHERE create_time >= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 5 MONTH),'%Y-%m-01') " +
                    "GROUP BY ym ORDER BY ym";

            Map<String, Long> addMap = new HashMap<>();
            jdbcTemplate.query(addSql, (org.springframework.jdbc.core.ResultSetExtractor<Void>) rs -> {
                while (rs.next()) {
                    addMap.put(rs.getString("ym"), rs.getLong("cnt"));
                }
                return null;
            });

            Map<String, Long> leaveMap = new HashMap<>();
            jdbcTemplate.query(leaveSql, (org.springframework.jdbc.core.ResultSetExtractor<Void>) rs -> {
                while (rs.next()) {
                    leaveMap.put(rs.getString("ym"), rs.getLong("cnt"));
                }
                return null;
            });

            LocalDate start = LocalDate.now().minusMonths(5).withDayOfMonth(1);
            List<String> months = new ArrayList<>();
            List<Long> addSeries = new ArrayList<>();
            List<Long> leaveSeries = new ArrayList<>();
            for (int i = 0; i < 6; i++) {
                LocalDate current = start.plusMonths(i);
                String ym = current.getYear() + "-" + String.format("%02d", current.getMonthValue());
                months.add(ym);
                addSeries.add(addMap.getOrDefault(ym, 0L));
                leaveSeries.add(leaveMap.getOrDefault(ym, 0L));
            }

            Map<String, Object> data = new HashMap<>();
            data.put("months", months);
            data.put("add", addSeries);
            data.put("leave", leaveSeries);
            return RetJson.success(data);
        } catch (Exception e) {
            return RetJson.error("Failed to load trend data: " + e.getMessage());
        }
    }
}
