package edu.cqie.eams.Interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**image.png
 * 权限拦截器
 * 限制普通用户访问管理员功能
 */
public class PermissionInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        
        String requestURI = request.getRequestURI();
        
        // 允许普通用户访问的路径（排除在权限检查之外）
        String[] allowedPaths = {
            "/employee/profile",      // 员工查看个人信息
            "/employee/updateProfile", // 员工更新个人信息
            "/employee/createProfile"  // 员工创建个人信息
        };
        
        // 检查是否是允许的路径
        for (String allowedPath : allowedPaths) {
            if (requestURI.contains(allowedPath)) {
                return true;  // 允许访问，直接通过
            }
        }
        
        // 需要管理员权限的路径
        String[] adminPaths = {
            "/department/", "/postlevel/", "/employee/", "/user/"
        };
        
        // 检查是否访问管理员功能
        boolean isAdminPath = false;
        for (String path : adminPaths) {
            if (requestURI.contains(path)) {
                isAdminPath = true;
                break;
            }
        }
        
        // 如果访问管理员功能但不是管理员，返回403
        if (isAdminPath && (isAdmin == null || !isAdmin)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><title>访问被拒绝</title></head>");
            response.getWriter().println("<body style='text-align:center; margin-top:100px;'>");
            response.getWriter().println("<h1>访问被拒绝</h1>");
            response.getWriter().println("<p>您没有权限访问此功能，请联系管理员。</p>");
            response.getWriter().println("<button onclick='history.back()'>返回</button>");
            response.getWriter().println("</body></html>");
            return false;
        }
        
        return true;
    }
} 