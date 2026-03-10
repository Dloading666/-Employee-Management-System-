<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>编辑岗位</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">编辑岗位</h3>
    <form action="${pageContext.request.contextPath}/postlevel/edit" method="post">
        <input type="hidden" name="id" value="${postLevel.id}" />
        <div class="form-group">
            <label>名称</label>
            <input type="text" class="form-control" name="name" value="${postLevel.name}" required />
        </div>
        <div class="form-group">
            <label>岗级</label>
            <input type="text" class="form-control" name="level" value="${postLevel.level}" />
        </div>
        <div class="form-group">
            <label>工资</label>
            <input type="number" class="form-control" name="salary" value="${postLevel.salary}" />
        </div>
        <div class="form-group">
            <label>排序码</label>
            <input type="number" class="form-control" name="sortCode" value="${postLevel.sortCode}" />
        </div>
        <div class="form-group">
            <label>状态</label>
            <input type="number" class="form-control" name="status" value="${postLevel.status}" />
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/postlevel/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
</body>
</html> 