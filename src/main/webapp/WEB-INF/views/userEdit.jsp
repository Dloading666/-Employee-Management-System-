<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>编辑用户</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">编辑用户</h3>
    <form action="${pageContext.request.contextPath}/user/edit" method="post">
        <input type="hidden" name="id" value="${user.id}" />
        <div class="form-group">
            <label>用户名</label>
            <input type="text" class="form-control" name="name" value="${user.name}" required />
        </div>
        <div class="form-group">
            <label>账号</label>
            <input type="text" class="form-control" name="account" value="${user.account}" required />
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" class="form-control" name="password" value="${user.password}" required />
        </div>
        <div class="form-group">
            <label>状态</label>
            <input type="number" class="form-control" name="status" value="${user.status}" />
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
</body>
</html> 