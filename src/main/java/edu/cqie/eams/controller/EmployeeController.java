package edu.cqie.eams.controller;

import edu.cqie.eams.domain.Employee;
import edu.cqie.eams.service.EmployeeService;
import edu.cqie.eams.service.DepartmentService;
import edu.cqie.eams.service.PostLevelService;
import edu.cqie.eams.comm.RetJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
/**
 * creater:吴少然
 */
@Controller
@RequestMapping("/employee")
public class EmployeeController {
    @Autowired
    private EmployeeService employeeService;
    
    @Autowired
    private DepartmentService departmentService;
    
    @Autowired
    private PostLevelService postLevelService;

    @GetMapping("/list")
    public String list() {
        return "redirect:/employee/page";
    }

    @GetMapping("/add")
    public String addPage() {
        return "employeeAdd";
    }

    @PostMapping("/add")
    public String add(Employee employee) {
        employeeService.addEmployee(employee);
        return "redirect:/employee/list";
    }

    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable("id") Long id, Model model) {
        Employee employee = employeeService.getEmployeeById(id);
        model.addAttribute("employee", employee);
        return "employeeEdit";
    }

    @PostMapping("/edit")
    public String edit(Employee employee, jakarta.servlet.http.HttpServletRequest request) {
        employeeService.updateEmployee(employee);
        request.setAttribute("editSuccess", true);
        return "employeeEdit";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id) {
        employeeService.deleteEmployee(id);
        return "redirect:/employee/list";
    }

    /**
     * AJAX 删除员工，避免整页跳转
     */
    @PostMapping("/deleteJson/{id}")
    @ResponseBody
    public RetJson<String> deleteJson(@PathVariable("id") Long id) {
        try {
            employeeService.deleteEmployee(id);
            return RetJson.success("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            return RetJson.error("删除失败：" + e.getMessage());
        }
    }

    @GetMapping("/page")
    public String page(
        @RequestParam(value = "name", required = false) String name,
        @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
        @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
        Model model) {
        if (pageNum == null || pageNum < 1) pageNum = 1;
        if (pageSize == null || pageSize < 1) pageSize = 10;
        List<Employee> employees = employeeService.getEmployeesByCondition(name, pageNum, pageSize);
        int total = employeeService.countEmployeesByCondition(name);
        model.addAttribute("employees", employees);
        model.addAttribute("total", total);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("name", name);
        return "employeeList";
    }

    /**
     * 员工个人信息查看（员工端入口）
     */
    @GetMapping("/profile")
    public String profile(jakarta.servlet.http.HttpSession session, Model model) {
        edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        Employee employee = employeeService.getByUserId(user.getId());
        model.addAttribute("employee", employee);
        model.addAttribute("currentUserId", user.getId()); // 传递当前用户ID，用于创建员工记录
        
        // 查询部门名称
        String deptName = null;
        if (employee != null && employee.getDeptId() != null) {
            try {
                edu.cqie.eams.domain.Department dept = departmentService.getDepartmentById(employee.getDeptId());
                if (dept != null) {
                    deptName = dept.getName();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        model.addAttribute("deptName", deptName);
        
        // 查询岗位名称
        String postLevelName = null;
        if (employee != null && employee.getPostLevelId() != null) {
            try {
                edu.cqie.eams.domain.PostLevel postLevel = postLevelService.getPostLevelById(employee.getPostLevelId());
                if (postLevel != null) {
                    postLevelName = postLevel.getName();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        model.addAttribute("postLevelName", postLevelName);
        
        return "employeeProfile";
    }
    
    /**
     * 员工更新自己的个人信息（AJAX接口）
     * 只允许更新部分字段，且只能更新自己的信息
     */
    @PostMapping("/updateProfile")
    @ResponseBody
    public RetJson<String> updateProfile(Employee employee, jakarta.servlet.http.HttpSession session) {
        try {
            edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
            if (user == null) {
                return RetJson.error("未登录");
            }
            
            // 获取当前员工的完整信息
            Employee currentEmployee = employeeService.getByUserId(user.getId());
            if (currentEmployee == null) {
                return RetJson.error("未找到员工信息");
            }
            
            // 验证只能更新自己的信息
            if (!currentEmployee.getId().equals(employee.getId())) {
                return RetJson.error("无权修改其他员工的信息");
            }
            
            // 只更新允许员工自己修改的字段
            currentEmployee.setName(employee.getName());
            currentEmployee.setEmail(employee.getEmail());
            currentEmployee.setMobile(employee.getMobile());
            currentEmployee.setHabitation(employee.getHabitation());
            currentEmployee.setSex(employee.getSex());
            currentEmployee.setBirthday(employee.getBirthday());
            currentEmployee.setMaritalStatus(employee.getMaritalStatus());
            currentEmployee.setGraduateSchool(employee.getGraduateSchool());
            currentEmployee.setMajorCode(employee.getMajorCode());
            currentEmployee.setHighestEducationCode(employee.getHighestEducationCode());
            currentEmployee.setHighestDegreeCode(employee.getHighestDegreeCode());
            
            // 执行更新（不更新敏感字段：工号、部门、岗位、入职日期、状态等）
            boolean success = employeeService.updateEmployee(currentEmployee);
            if (success) {
                return RetJson.success("保存成功");
            } else {
                return RetJson.error("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return RetJson.error("保存失败：" + e.getMessage());
        }
    }
    
    /**
     * 员工创建自己的个人信息（当没有员工记录时）
     */
    @PostMapping("/createProfile")
    @ResponseBody
    public RetJson<String> createProfile(Employee employee, jakarta.servlet.http.HttpSession session) {
        try {
            edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
            if (user == null) {
                return RetJson.error("未登录");
            }
            
            // 检查是否已有员工记录
            Employee existingEmployee = employeeService.getByUserId(user.getId());
            if (existingEmployee != null) {
                return RetJson.error("您已有员工档案，请使用编辑功能");
            }
            
            // 设置用户ID和默认值
            employee.setUserId(user.getId());
            if (employee.getStatus() == null) {
                employee.setStatus(1); // 默认在职
            }
            if (employee.getRoleType() == null) {
                employee.setRoleType(3); // 默认普通员工
            }
            
            // 创建员工记录
            boolean success = employeeService.addEmployee(employee);
            if (success) {
                return RetJson.success("创建成功");
            } else {
                return RetJson.error("创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return RetJson.error("创建失败：" + e.getMessage());
        }
    }
}
