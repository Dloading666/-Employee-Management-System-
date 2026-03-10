<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>添加部门</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .card { margin: 60px auto; max-width: 500px; }
        .btn-primary { background: #2196f3; border: none; border-radius: 6px; }
        .btn-primary:hover { background: #1976d2; }
    </style>
</head>
<body>
<div class="container">
    <div class="card p-4 shadow">
        <h3 class="mb-4 text-center">添加部门</h3>
        <form action="${pageContext.request.contextPath}/department/add" method="post">
            <div class="form-group">
                <label>部门名称</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="form-group">
                <label>负责人用户ID</label>
                <input type="number" class="form-control" name="managerUserId">
            </div>
            <div class="form-group">
                <label>上级部门ID</label>
                <input type="number" class="form-control" name="parentId">
            </div>
            <div class="form-group">
                <label>排序码</label>
                <input type="number" class="form-control" name="sortCode">
            </div>
            <div class="form-group">
                <label>状态</label>
                <select class="form-control" name="status">
                    <option value="1">启用</option>
                    <option value="0">禁用</option>
                </select>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary px-5">保存</button>
            </div>
        </form>
    </div>
</div>
</body>
</html> 