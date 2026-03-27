package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.Employee;
import edu.com.eams.service.EmployeeService;
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
@RequestMapping("/api/employees")
public class EmployeeApiController {

    private final EmployeeService employeeService;

    public EmployeeApiController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    public RetJson<PageResult<Employee>> list(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        List<Employee> records = employeeService.getEmployeesByCondition(name, safePageNum, safePageSize);
        int total = employeeService.countEmployeesByCondition(name);
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @GetMapping("/{id}")
    public RetJson<Employee> detail(@PathVariable("id") Long id) {
        Employee employee = employeeService.getEmployeeById(id);
        if (employee == null) {
            return new RetJson<>(404, "Employee not found", null);
        }
        return RetJson.success(employee);
    }

    @PostMapping
    public RetJson<Employee> create(@RequestBody Employee employee) {
        boolean success = employeeService.addEmployee(employee);
        if (!success) {
            return RetJson.error("Failed to create employee");
        }
        return RetJson.success(employee);
    }

    @PutMapping("/{id}")
    public RetJson<Employee> update(@PathVariable("id") Long id, @RequestBody Employee employee) {
        employee.setId(id);
        boolean success = employeeService.updateEmployee(employee);
        if (!success) {
            return RetJson.error("Failed to update employee");
        }
        return RetJson.success(employeeService.getEmployeeById(id));
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id) {
        boolean success = employeeService.deleteEmployee(id);
        if (!success) {
            return RetJson.error("Failed to delete employee");
        }
        return RetJson.success("Deleted");
    }
}
