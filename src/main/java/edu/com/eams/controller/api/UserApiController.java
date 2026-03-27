package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.User;
import edu.com.eams.service.UserService;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserApiController {

    private final UserService userService;

    public UserApiController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public RetJson<PageResult<Map<String, Object>>> list(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int start = (safePageNum - 1) * safePageSize;
        List<User> users = userService.getUsersByCondition(name, start, safePageSize);
        int total = userService.countUsersByCondition(name);
        List<Map<String, Object>> records = users.stream().map(this::toView).toList();
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @GetMapping("/{id}")
    public RetJson<Map<String, Object>> detail(@PathVariable("id") Long id) {
        User user = userService.getUserById(id);
        if (user == null) {
            return new RetJson<>(404, "User not found", null);
        }
        return RetJson.success(toView(user));
    }

    @PostMapping
    public RetJson<Map<String, Object>> create(@RequestBody User user) {
        boolean success = userService.addUser(user);
        if (!success) {
            return RetJson.error("Failed to create user");
        }
        return RetJson.success(toView(user));
    }

    @PutMapping("/{id}")
    public RetJson<Map<String, Object>> update(@PathVariable("id") Long id, @RequestBody User user) {
        user.setId(id);
        boolean success = userService.updateUser(user);
        if (!success) {
            return RetJson.error("Failed to update user");
        }
        User saved = userService.getUserById(id);
        return RetJson.success(saved == null ? toView(user) : toView(saved));
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id) {
        boolean success = userService.deleteUser(id);
        if (!success) {
            return RetJson.error("Failed to delete user");
        }
        return RetJson.success("Deleted");
    }

    private Map<String, Object> toView(User user) {
        Map<String, Object> data = new HashMap<>();
        data.put("id", user.getId());
        data.put("name", user.getName());
        data.put("account", user.getAccount());
        data.put("status", user.getStatus());
        data.put("passwordMasked", StringUtils.hasText(user.getPassword()) ? "******" : "");
        data.put("passwordConfigured", StringUtils.hasText(user.getPassword()));
        return data;
    }
}
