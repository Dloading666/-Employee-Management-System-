package edu.com.eams.controller.api;

import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.User;
import edu.com.eams.security.SessionUserSupport;
import edu.com.eams.service.LoginService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthApiController {

    private final LoginService loginService;

    public AuthApiController(LoginService loginService) {
        this.loginService = loginService;
    }

    @PostMapping("/login")
    public RetJson<Map<String, Object>> login(@RequestBody LoginRequest request,
                                              HttpServletRequest httpServletRequest) {
        User user = loginService.login(request.getAccount(), request.getPassword());
        if (user == null) {
            return new RetJson<>(401, "Invalid account or password", null);
        }

        User sessionUser = SessionUserSupport.sanitize(user);
        HttpSession session = httpServletRequest.getSession();
        boolean isAdmin = "admin".equalsIgnoreCase(sessionUser.getAccount());
        session.setAttribute("currentUser", sessionUser);
        session.setAttribute("isAdmin", isAdmin);

        Map<String, Object> data = buildAuthPayload(sessionUser, isAdmin);
        return RetJson.success(data);
    }

    @PostMapping("/logout")
    public RetJson<String> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        SecurityContextHolder.clearContext();
        return RetJson.success("Logged out");
    }

    @GetMapping("/me")
    public RetJson<Map<String, Object>> me(HttpSession session) {
        User user = SessionUserSupport.getCurrentUser(session);
        if (user == null) {
            return new RetJson<>(401, "Not logged in", null);
        }
        return RetJson.success(buildAuthPayload(user, SessionUserSupport.isAdmin(session)));
    }

    private Map<String, Object> buildAuthPayload(User user, boolean isAdmin) {
        Map<String, Object> data = new HashMap<>();
        data.put("user", user);
        data.put("isAdmin", isAdmin);
        data.put("role", isAdmin ? "ADMIN" : "EMPLOYEE");
        return data;
    }

    public static class LoginRequest {
        private String account;
        private String password;

        public String getAccount() {
            return account;
        }

        public void setAccount(String account) {
            this.account = account;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }
}
