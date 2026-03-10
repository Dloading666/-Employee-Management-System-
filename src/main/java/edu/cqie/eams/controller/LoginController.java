package edu.cqie.eams.controller;

import edu.cqie.eams.comm.RetJson;
import edu.cqie.eams.domain.User;
import edu.cqie.eams.service.LoginService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 登录控制器
 */
@Controller
public class LoginController {

    @Autowired
    private LoginService loginService;

    /**
     * 根路径跳转到登录页面
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    /**
     * 登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login"; // /WEB-INF/views/login.jsp
    }

    /**
     * 登录提交
     */
    @PostMapping("/doLogin")
    @ResponseBody
    public RetJson<User> doLogin(@org.springframework.web.bind.annotation.RequestParam("account") String account,
                                 @org.springframework.web.bind.annotation.RequestParam("password") String password,
                                 HttpServletRequest request) {
        try {
            User user = loginService.login(account, password);
            if (user == null) {
                return RetJson.error("账号或密码错误");
            }
            // 登录成功，保存会话
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setAttribute("isAdmin", "admin".equalsIgnoreCase(user.getAccount()));
            return RetJson.success(user);
        } catch (Exception e) {
            return RetJson.error("登录异常: " + e.getMessage());
        }
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        session.invalidate();
        return "redirect:/login";
    }
} 