<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>员工考勤管理系统 - 主页</title>
    <link href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/common.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Microsoft YaHei', sans-serif;
        }
        
        .topbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .sidebar {
            min-height: calc(100vh - 70px);
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            padding: 0;
        }
        
        .nav-link {
            color: #333;
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
        }
        
        .nav-link:hover {
            background: #f8f9fa;
            color: #667eea;
            text-decoration: none;
        }
        
        .nav-link.active {
            background: #667eea;
            color: white;
        }
        
        .main-content {
            padding: 0;
            height: calc(100vh - 70px);
            overflow: hidden;
        }
        
        iframe {
            width: 100%;
            height: 100%;
            border: none;
            background: white;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .badge-role {
            font-size: 12px;
            padding: 4px 8px;
        }
        
        .logout-btn {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            background: rgba(255,255,255,0.2);
            transition: all 0.3s ease;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <!-- 顶部导航栏 -->
        <div class="topbar d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <button id="toggleSidebar" class="btn btn-sm btn-light mr-3" style="border-radius:4px;">
                    ☰
                </button>
                <h4 class="mb-0">员工考勤管理系统</h4>
            </div>
            <div class="user-info">
                <span id="userInfo">加载中...</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    退出登录
                </a>
            </div>
        </div>
        
        <!-- 主体内容 -->
        <div class="row no-gutters">
            <!-- 左侧菜单 -->
            <div class="col-2 sidebar">
                <ul class="nav flex-column" id="menuList">
                    <li class="nav-item">
                        <a class="nav-link active" href="#" onclick="loadPage('${pageContext.request.contextPath}/welcome.jsp', this)">
                            🏠 系统首页
                        </a>
                    </li>
                    
                    <!-- 管理员菜单 -->
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/department/list', this)">
                            🏢 部门管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/employee/list', this)">
                            👥 员工管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/user/list', this)">
                            👤 用户管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/attendance/list', this)">
                            📊 考勤管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/notice/list', this)">
                            📢 公告管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/salary/list', this)">
                            💰 薪资管理
                        </a>
                    </li>
                    <li class="nav-item admin-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/leave/page', this)">
                            📝 请假审批
                        </a>
                    </li>
                    
                    <!-- 普通用户菜单 -->
                    <li class="nav-item user-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/attendance/my', this)">
                            📈 我的考勤
                        </a>
                    </li>
                    <li class="nav-item user-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/leave/add', this)">
                            ✍️ 请假申请
                        </a>
                    </li>
                    <li class="nav-item user-menu" style="display: none;">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/leave/my', this)">
                            📋 我的请假
                        </a>
                    </li>
                    
                    <!-- 系统测试菜单 -->
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="loadPage('${pageContext.request.contextPath}/test/info', this)">
                            🔧 系统测试
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- 右侧内容区域 -->
            <div class="col-10 main-content">
                <iframe id="mainFrame" src="${pageContext.request.contextPath}/welcome.jsp"></iframe>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/jquery-3.6.1.js"></script>
    <script src="${pageContext.request.contextPath}/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/layer/layer.js"></script>
    
    <script>
        // 加载页面
        function loadPage(url, element) {
            document.getElementById('mainFrame').src = url;
            $('.nav-link').removeClass('active');
            $(element).addClass('active');
        }
        
        $(document).ready(function() {
            // 侧边栏折叠/展开
            $('#toggleSidebar').on('click', function () {
                $('.sidebar').toggleClass('d-none');
                $('.main-content').toggleClass('col-10 col-12');
            });

            // 获取当前用户信息
            $.ajax({
                url: '${pageContext.request.contextPath}/getCurrentUser',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    console.log('用户信息响应:', response);
                    
                    if (response.success) {
                        var user = response.data.user;
                        var isAdmin = response.data.isAdmin;
                        
                        // 显示用户信息
                        var roleText = isAdmin ? '管理员' : '普通用户';
                        var roleClass = isAdmin ? 'badge-danger' : 'badge-info';
                        
                        $('#userInfo').html(
                            '欢迎，<strong>' + user.name + '</strong> ' +
                            '<span class="badge ' + roleClass + ' badge-role">' + roleText + '</span>'
                        );
                        
                        // 根据权限显示菜单
                        if (isAdmin) {
                            $('.admin-menu').show();
                            $('.user-menu').hide();
                        } else {
                            $('.admin-menu').hide();
                            $('.user-menu').show();
                        }
                    } else {
                        layer.msg('获取用户信息失败：' + response.message, {icon: 2});
                        setTimeout(function() {
                            window.location.href = '${pageContext.request.contextPath}/login';
                        }, 2000);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('获取用户信息失败:', error);
                    layer.msg('网络错误，请重新登录', {icon: 2});
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 2000);
                }
            });
        });
    </script>
</body>
</html> 