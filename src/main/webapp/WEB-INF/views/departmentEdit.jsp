<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>编辑部门</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">编辑部门</h3>
    <form action="${pageContext.request.contextPath}/department/edit" method="post">
        <input type="hidden" name="id" value="${department.id}" />
        <div class="form-group">
            <label>名称</label>
            <input type="text" class="form-control" name="name" value="${department.name}" required />
        </div>
        <div class="form-group">
            <label>负责人ID</label>
            <input type="number" class="form-control" name="managerUserId" value="${department.managerUserId}" />
        </div>
        <div class="form-group">
            <label>上级部门ID</label>
            <input type="number" class="form-control" name="parentId" value="${department.parentId}" />
        </div>
        <div class="form-group">
            <label>排序码</label>
            <input type="number" class="form-control" name="sortCode" value="${department.sortCode}" />
        </div>
        <div class="form-group">
            <label>状态</label>
            <input type="number" class="form-control" name="status" value="${department.status}" />
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/department/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
</body>
</html> 