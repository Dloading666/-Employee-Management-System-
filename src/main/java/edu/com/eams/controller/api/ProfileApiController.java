package edu.com.eams.controller.api;

import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.Department;
import edu.com.eams.domain.Employee;
import edu.com.eams.domain.PostLevel;
import edu.com.eams.domain.User;
import edu.com.eams.security.SessionUserSupport;
import edu.com.eams.service.DepartmentService;
import edu.com.eams.service.EmployeeService;
import edu.com.eams.service.PostLevelService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/profile")
public class ProfileApiController {

    private final EmployeeService employeeService;
    private final DepartmentService departmentService;
    private final PostLevelService postLevelService;

    public ProfileApiController(EmployeeService employeeService,
                                DepartmentService departmentService,
                                PostLevelService postLevelService) {
        this.employeeService = employeeService;
        this.departmentService = departmentService;
        this.postLevelService = postLevelService;
    }

    @GetMapping
    public RetJson<Map<String, Object>> detail(HttpSession session) {
        User user = SessionUserSupport.getCurrentUser(session);
        if (user == null) {
            return new RetJson<>(401, "Not logged in", null);
        }
        return RetJson.success(buildPayload(user));
    }

    @PostMapping
    public RetJson<Map<String, Object>> create(@RequestBody Employee input, HttpSession session) {
        User user = SessionUserSupport.getCurrentUser(session);
        if (user == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        Employee existing = employeeService.getByUserId(user.getId());
        if (existing != null) {
            return new RetJson<>(400, "Profile already exists", null);
        }

        Employee employee = new Employee();
        employee.setUserId(user.getId());
        employee.setStatus(1);
        employee.setRoleType(3);
        applyEditableFields(employee, input, true);

        boolean success = employeeService.addEmployee(employee);
        if (!success) {
            return RetJson.error("Failed to create profile");
        }
        return RetJson.success(buildPayload(user));
    }

    @PutMapping
    public RetJson<Map<String, Object>> update(@RequestBody Employee input, HttpSession session) {
        User user = SessionUserSupport.getCurrentUser(session);
        if (user == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        Employee employee = employeeService.getByUserId(user.getId());
        if (employee == null) {
            return new RetJson<>(404, "Profile not found", null);
        }
        if (input.getId() != null && !employee.getId().equals(input.getId())) {
            return new RetJson<>(403, "Access denied", null);
        }

        applyEditableFields(employee, input, false);
        boolean success = employeeService.updateEmployee(employee);
        if (!success) {
            return RetJson.error("Failed to update profile");
        }
        return RetJson.success(buildPayload(user));
    }

    private Map<String, Object> buildPayload(User user) {
        Employee employee = employeeService.getByUserId(user.getId());
        Map<String, Object> payload = new HashMap<>();
        payload.put("currentUser", SessionUserSupport.sanitize(user));
        payload.put("currentUserId", user.getId());
        payload.put("employee", employee);
        payload.put("deptName", resolveDeptName(employee));
        payload.put("postLevelName", resolvePostLevelName(employee));
        return payload;
    }

    private String resolveDeptName(Employee employee) {
        if (employee == null || employee.getDeptId() == null) {
            return null;
        }
        Department department = departmentService.getDepartmentById(employee.getDeptId());
        return department == null ? null : department.getName();
    }

    private String resolvePostLevelName(Employee employee) {
        if (employee == null || employee.getPostLevelId() == null) {
            return null;
        }
        PostLevel postLevel = postLevelService.getPostLevelById(employee.getPostLevelId());
        return postLevel == null ? null : postLevel.getName();
    }

    private void applyEditableFields(Employee target, Employee source, boolean allowCode) {
        if (source == null) {
            return;
        }
        target.setName(source.getName());
        if (allowCode) {
            target.setCode(source.getCode());
        }
        target.setEmail(source.getEmail());
        target.setMobile(source.getMobile());
        target.setHabitation(source.getHabitation());
        target.setSex(source.getSex());
        target.setBirthday(source.getBirthday());
        target.setMaritalStatus(source.getMaritalStatus());
        target.setGraduateSchool(source.getGraduateSchool());
        target.setMajorCode(source.getMajorCode());
        target.setHighestEducationCode(source.getHighestEducationCode());
        target.setHighestDegreeCode(source.getHighestDegreeCode());
    }
}
