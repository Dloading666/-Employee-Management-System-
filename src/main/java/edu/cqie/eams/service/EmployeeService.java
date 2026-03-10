package edu.cqie.eams.service;

import edu.cqie.eams.domain.Employee;
import java.util.List;
/**
 * creater:吴少然
 */
public interface EmployeeService {
    List<Employee> getAllEmployees();
    Employee getEmployeeById(Long id);
    boolean addEmployee(Employee employee);
    boolean updateEmployee(Employee employee);
    boolean deleteEmployee(Long id);
    List<Employee> getEmployeesByCondition(String name, int pageNum, int pageSize);
    int countEmployeesByCondition(String name);
    Employee getByUserId(Long userId);
}
