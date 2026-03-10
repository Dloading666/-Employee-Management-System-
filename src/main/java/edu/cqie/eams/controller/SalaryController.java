package edu.cqie.eams.controller;

import edu.cqie.eams.comm.RetJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/salary")
public class SalaryController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 管理员查看薪资列表
     */
    @GetMapping("/list")
    public String list(Model model) {
        List<Map<String, Object>> list = jdbcTemplate.query("SELECT * FROM emp_salary ORDER BY pay_month DESC, create_time DESC",
                (rs, i) -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("id", rs.getLong("id"));
                    m.put("userId", rs.getLong("user_id"));
                    m.put("userName", rs.getString("user_name"));
                    m.put("payMonth", rs.getString("pay_month"));
                    m.put("amount", rs.getBigDecimal("amount"));
                    m.put("remark", rs.getString("remark"));
                    m.put("createTime", rs.getTimestamp("create_time"));
                    return m;
                });
        model.addAttribute("records", list);
        return "salaryList";
    }

    /**
     * 管理员新增薪资记录
     */
    @PostMapping("/add")
    public String add(@RequestParam(value = "userId", required = false) Long userId,
                      @RequestParam("userName") String userName,
                      @RequestParam("payMonth") String payMonth,
                      @RequestParam("amount") BigDecimal amount,
                      @RequestParam(value = "remark", required = false) String remark) {
        // 如果没有手动填写用户ID，则根据姓名反查用户ID（取第一条）
        if (userId == null) {
            try {
                List<Long> ids = jdbcTemplate.queryForList(
                        "SELECT id FROM sys_user WHERE name = ?",
                        new Object[]{userName},
                        Long.class
                );
                if (ids == null || ids.isEmpty()) {
                    // 没查到对应用户，暂时不插入，直接回列表（可根据需要改成提示）
                    return "redirect:/salary/list";
                }
                userId = ids.get(0);
            } catch (Exception e) {
                // 查询异常，同样不插入，避免抛 500
                e.printStackTrace();
                return "redirect:/salary/list";
            }
        }
        jdbcTemplate.update("INSERT INTO emp_salary (user_id, user_name, pay_month, amount, remark, create_time) VALUES (?,?,?,?,?,?)",
                userId, userName, payMonth, amount, remark, Timestamp.valueOf(LocalDateTime.now()));
        return "redirect:/salary/list";
    }

    /**
     * 管理员通过 AJAX 删除薪资记录
     */
    @PostMapping("/deleteJson/{id}")
    @ResponseBody
    public RetJson<String> deleteJson(@PathVariable("id") Long id) {
        try {
            jdbcTemplate.update("DELETE FROM emp_salary WHERE id=?", id);
            return RetJson.success("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            return RetJson.error("删除失败:" + e.getMessage());
        }
    }

    /**
     * 员工查看自己的薪资记录
     */
    @GetMapping("/my")
    public String mySalary(jakarta.servlet.http.HttpSession session, Model model) {
        edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        List<Map<String, Object>> list = jdbcTemplate.query(
                "SELECT * FROM emp_salary WHERE user_id=? ORDER BY pay_month DESC, create_time DESC",
                new Object[]{user.getId()},
                (rs, i) -> {
                    Map<String, Object> m = new HashMap<>();
                    m.put("payMonth", rs.getString("pay_month"));
                    m.put("amount", rs.getBigDecimal("amount"));
                    m.put("remark", rs.getString("remark"));
                    m.put("createTime", rs.getTimestamp("create_time"));
                    return m;
                });
        model.addAttribute("records", list);
        return "mySalary";
    }
}

