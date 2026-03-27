package edu.com.eams.controller.api;

import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.User;
import edu.com.eams.security.SessionUserSupport;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/salaries")
public class SalaryApiController {

    private final JdbcTemplate jdbcTemplate;

    public SalaryApiController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping
    public RetJson<List<Map<String, Object>>> list(
            @RequestParam(value = "userName", required = false) String userName,
            @RequestParam(value = "payMonth", required = false) String payMonth,
            HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }

        StringBuilder sql = new StringBuilder(
                "SELECT id, user_id, user_name, pay_month, amount, remark, create_time FROM emp_salary WHERE 1=1"
        );
        List<Object> args = new ArrayList<>();
        if (StringUtils.hasText(userName)) {
            sql.append(" AND user_name LIKE ?");
            args.add("%" + userName.trim() + "%");
        }
        if (StringUtils.hasText(payMonth)) {
            sql.append(" AND pay_month = ?");
            args.add(payMonth.trim());
        }
        sql.append(" ORDER BY pay_month DESC, create_time DESC");

        List<Map<String, Object>> records = jdbcTemplate.query(sql.toString(), args.toArray(), (rs, rowNum) -> {
            Map<String, Object> row = new HashMap<>();
            row.put("id", rs.getLong("id"));
            row.put("userId", rs.getLong("user_id"));
            row.put("userName", rs.getString("user_name"));
            row.put("payMonth", rs.getString("pay_month"));
            row.put("amount", rs.getBigDecimal("amount"));
            row.put("remark", rs.getString("remark"));
            row.put("createTime", rs.getTimestamp("create_time") == null ? null : rs.getTimestamp("create_time").toLocalDateTime().toString());
            return row;
        });
        return RetJson.success(records);
    }

    @GetMapping("/mine")
    public RetJson<List<Map<String, Object>>> mine(HttpSession session) {
        User user = SessionUserSupport.getCurrentUser(session);
        if (user == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        List<Map<String, Object>> records = jdbcTemplate.query(
                "SELECT id, user_id, user_name, pay_month, amount, remark, create_time FROM emp_salary WHERE user_id=? ORDER BY pay_month DESC, create_time DESC",
                new Object[]{user.getId()},
                (rs, rowNum) -> {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getLong("id"));
                    row.put("userId", rs.getLong("user_id"));
                    row.put("userName", rs.getString("user_name"));
                    row.put("payMonth", rs.getString("pay_month"));
                    row.put("amount", rs.getBigDecimal("amount"));
                    row.put("remark", rs.getString("remark"));
                    row.put("createTime", rs.getTimestamp("create_time") == null ? null : rs.getTimestamp("create_time").toLocalDateTime().toString());
                    return row;
                }
        );
        return RetJson.success(records);
    }

    @PostMapping
    public RetJson<Map<String, Object>> create(@RequestBody SalaryRequest request, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        if (request == null || !StringUtils.hasText(request.getUserName()) || !StringUtils.hasText(request.getPayMonth()) || request.getAmount() == null) {
            return new RetJson<>(400, "User name, pay month and amount are required", null);
        }

        Long userId = resolveUserId(request.getUserId(), request.getUserName());
        if (userId == null) {
            return new RetJson<>(400, "User not found", null);
        }

        String normalizedUserName = resolveUserName(userId, request.getUserName());
        Timestamp now = Timestamp.valueOf(LocalDateTime.now());
        jdbcTemplate.update(
                "INSERT INTO emp_salary (user_id, user_name, pay_month, amount, remark, create_time) VALUES (?,?,?,?,?,?)",
                userId,
                normalizedUserName,
                request.getPayMonth().trim(),
                request.getAmount(),
                StringUtils.hasText(request.getRemark()) ? request.getRemark().trim() : null,
                now
        );

        Map<String, Object> data = new HashMap<>();
        data.put("userId", userId);
        data.put("userName", normalizedUserName);
        data.put("payMonth", request.getPayMonth().trim());
        data.put("amount", request.getAmount());
        data.put("remark", StringUtils.hasText(request.getRemark()) ? request.getRemark().trim() : null);
        data.put("createTime", now.toLocalDateTime().toString());
        return RetJson.success(data);
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        jdbcTemplate.update("DELETE FROM emp_salary WHERE id=?", id);
        return RetJson.success("Deleted");
    }

    private Long resolveUserId(Long userId, String userName) {
        if (userId != null) {
            List<Long> ids = jdbcTemplate.queryForList("SELECT id FROM sys_user WHERE id = ?", Long.class, userId);
            if (!ids.isEmpty()) {
                return ids.get(0);
            }
        }
        if (!StringUtils.hasText(userName)) {
            return null;
        }
        List<Long> ids = jdbcTemplate.queryForList("SELECT id FROM sys_user WHERE name = ?", Long.class, userName.trim());
        return ids.isEmpty() ? null : ids.get(0);
    }

    private String resolveUserName(Long userId, String fallback) {
        List<String> names = jdbcTemplate.queryForList("SELECT name FROM sys_user WHERE id = ?", String.class, userId);
        if (!names.isEmpty()) {
            return names.get(0);
        }
        return fallback;
    }

    public static class SalaryRequest {
        private Long userId;
        private String userName;
        private String payMonth;
        private BigDecimal amount;
        private String remark;

        public Long getUserId() {
            return userId;
        }

        public void setUserId(Long userId) {
            this.userId = userId;
        }

        public String getUserName() {
            return userName;
        }

        public void setUserName(String userName) {
            this.userName = userName;
        }

        public String getPayMonth() {
            return payMonth;
        }

        public void setPayMonth(String payMonth) {
            this.payMonth = payMonth;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }
}
