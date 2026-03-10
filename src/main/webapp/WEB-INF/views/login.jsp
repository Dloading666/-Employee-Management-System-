<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>系统登录</title>
    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="<%=request.getContextPath()%>/static/jquery-3.6.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f5f5f5;
        }
        .login-panel {
            max-width: 400px;
            margin: 120px auto;
            padding: 40px 30px 30px;
            border-radius: 10px;
            background: #ffffff;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        }
        .login-panel h3 {
            margin-bottom: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="login-panel">
    <h3>企业员工管理系统</h3>
    <form id="loginForm">
        <div class="mb-3">
            <label for="account" class="form-label">账号</label>
            <input type="text" class="form-control" id="account" name="account" required/>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">密码</label>
            <input type="password" class="form-control" id="password" name="password" required/>
        </div>
        <button type="submit" class="btn btn-primary w-100">登录</button>
    </form>
</div>

<script>
    $(function () {
        $('#loginForm').on('submit', function (e) {
            e.preventDefault();
            const account = $('#account').val().trim();
            const password = $('#password').val();
            if (!account || !password) {
                alert('请输入账号和密码');
                return;
            }
            $.post('<%=request.getContextPath()%>/doLogin', {
                account: account,
                password: password
            }).done(function (res) {
                if (res.code === 200) {
                    // 根据用户角色跳转到不同页面
                    var user = res.data;
                    var isAdmin = user && user.account && user.account.toLowerCase() === 'admin';
                    if (isAdmin) {
                        window.location.href = '<%=request.getContextPath()%>/main.jsp';
                    } else {
                        window.location.href = '<%=request.getContextPath()%>/userMain.jsp';
                    }
                } else {
                    alert(res.msg || '登录失败');
                }
            }).fail(function (xhr) {
                alert('登录请求失败: ' + xhr.status);
                console.error(xhr.responseText);
            });
        });
    });
</script>
</body>
</html> 