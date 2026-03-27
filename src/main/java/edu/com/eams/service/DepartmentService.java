package edu.com.eams.service;

import edu.com.eams.domain.Department;
import java.util.List;

public interface DepartmentService {
    List<Department> getAllDepartments();
    Department getDepartmentById(Long id);
    boolean addDepartment(Department department);
    boolean updateDepartment(Department department);
    boolean deleteDepartment(Long id);
    List<Department> getDepartmentsByCondition(String name, int start, int size);
    int countDepartmentsByCondition(String name);
} 