package edu.com.eams.security;

import edu.com.eams.domain.User;
import jakarta.servlet.http.HttpSession;

public final class SessionUserSupport {

    private SessionUserSupport() {
    }

    public static User getCurrentUser(HttpSession session) {
        Object currentUser = session.getAttribute("currentUser");
        if (currentUser instanceof User user) {
            return user;
        }
        return null;
    }

    public static boolean isAdmin(HttpSession session) {
        User user = getCurrentUser(session);
        return Boolean.TRUE.equals(session.getAttribute("isAdmin"))
                || (user != null && "admin".equalsIgnoreCase(user.getAccount()));
    }

    public static User sanitize(User source) {
        if (source == null) {
            return null;
        }
        User user = new User();
        user.setId(source.getId());
        user.setName(source.getName());
        user.setAccount(source.getAccount());
        user.setStatus(source.getStatus());
        return user;
    }
}
