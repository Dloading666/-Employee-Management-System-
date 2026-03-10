package edu.cqie.eams.controller;

import edu.cqie.eams.domain.User;
import edu.cqie.eams.service.UserService;
import edu.cqie.eams.comm.RetJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public String list() {
        return "redirect:/user/page";
    }

    @GetMapping("/add")
    public String addForm() {
        return "userAdd";
    }

    @PostMapping("/add")
    public String add(User user) {
        userService.addUser(user);
        return "redirect:/user/list";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("user", userService.getUserById(id));
        return "userEdit";
    }

    @PostMapping("/edit")
    public String edit(User user) {
        userService.updateUser(user);
        return "redirect:/user/list";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id) {
        userService.deleteUser(id);
        return "redirect:/user/list";
    }

    /**
     * AJAX 删除用户，避免整页跳转
     */
    @PostMapping("/deleteJson/{id}")
    @ResponseBody
    public RetJson<String> deleteJson(@PathVariable("id") Long id) {
        try {
            userService.deleteUser(id);
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
        if (start < 0) start = 0;
        List<User> users = userService.getUsersByCondition(name, start, pageSize);
        int total = userService.countUsersByCondition(name);
        model.addAttribute("users", users);
        model.addAttribute("total", total);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("name", name);
        return "userList";
    }
} 