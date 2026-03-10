package edu.cqie.eams.controller;

import edu.cqie.eams.domain.Department;
import edu.cqie.eams.service.DepartmentService;
import edu.cqie.eams.comm.RetJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/department")
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;

    @GetMapping("/list")
    public String list() {
        return "redirect:/department/page";
    }

    @GetMapping("/add")
    public String addForm() {
        return "departmentAdd";
    }

    @PostMapping("/add")
    public String add(Department department) {
        departmentService.addDepartment(department);
        return "redirect:/department/list";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("department", departmentService.getDepartmentById(id));
        return "departmentEdit";
    }

    @PostMapping("/edit")
    public String edit(Department department) {
        departmentService.updateDepartment(department);
        return "redirect:/department/list";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id) {
        departmentService.deleteDepartment(id);
        return "redirect:/department/list";
    }

    /**
     * AJAX 删除接口，供前端异步调用，避免页面跳转和丢失当前分页、查询条件
     */
    @PostMapping("/deleteJson/{id}")
    @ResponseBody
    public RetJson<String> deleteJson(@PathVariable("id") Long id) {
        try {
            departmentService.deleteDepartment(id);
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
        int start = (pageNum - 1) * pageSize;
        List<Department> departments = departmentService.getDepartmentsByCondition(name, start, pageSize);
        int total = departmentService.countDepartmentsByCondition(name);
        model.addAttribute("departments", departments);
        model.addAttribute("total", total);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("name", name);
        return "departmentList";
    }
} 