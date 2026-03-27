package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.Department;
import edu.com.eams.service.DepartmentService;
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
@RequestMapping("/api/departments")
public class DepartmentApiController {

    private final DepartmentService departmentService;

    public DepartmentApiController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    @GetMapping
    public RetJson<PageResult<Department>> list(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int start = (safePageNum - 1) * safePageSize;
        List<Department> records = departmentService.getDepartmentsByCondition(name, start, safePageSize);
        int total = departmentService.countDepartmentsByCondition(name);
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @GetMapping("/{id}")
    public RetJson<Department> detail(@PathVariable("id") Long id) {
        Department department = departmentService.getDepartmentById(id);
        if (department == null) {
            return new RetJson<>(404, "Department not found", null);
        }
        return RetJson.success(department);
    }

    @PostMapping
    public RetJson<Department> create(@RequestBody Department department) {
        boolean success = departmentService.addDepartment(department);
        if (!success) {
            return RetJson.error("Failed to create department");
        }
        return RetJson.success(department);
    }

    @PutMapping("/{id}")
    public RetJson<Department> update(@PathVariable("id") Long id, @RequestBody Department department) {
        department.setId(id);
        boolean success = departmentService.updateDepartment(department);
        if (!success) {
            return RetJson.error("Failed to update department");
        }
        return RetJson.success(departmentService.getDepartmentById(id));
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id) {
        boolean success = departmentService.deleteDepartment(id);
        if (!success) {
            return RetJson.error("Failed to delete department");
        }
        return RetJson.success("Deleted");
    }
}
