<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>用户列表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .table thead th { background: #2196f3; color: #fff; }
        .btn-primary { background: #2196f3; border: none; border-radius: 6px; }
        .btn-primary:hover { background: #1976d2; }
        .btn-danger { border-radius: 6px; }
        .card { margin-top: 32px; }
    </style>
</head>
<body>
<div class="container card p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">用户列表</h3>
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addUserModal">
            添加用户
        </button>
    </div>
    <form class="form-inline search-bar" method="get" action="${pageContext.request.contextPath}/user/page">
        <input type="text" class="form-control mr-2" name="name" value="${name}" placeholder="用户名"/>
        <button type="submit" class="btn btn-primary">搜索</button>
    </form>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-sm">
            <thead>
            <tr>
                <th class="d-none">ID</th>
                <th>用户名</th>
                <th>账号</th>
                <th>密码</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td class="d-none">${u.id}</td>
                    <td>${u.name}</td>
                    <td>${u.account}</td>
                    <td>${u.password}</td>
                    <td>${u.status}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/user/edit/${u.id}" class="btn btn-sm btn-primary" target="mainFrame">编辑</a>
                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteUser(${u.id})">删除</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 分页按钮 -->
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/user/page"/>
    <c:set var="query" value="name=${name}"/>
    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
</div>

<!-- 添加用户弹窗 -->
<div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">添加用户</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/user/add" method="post">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>账号</label>
                        <input type="text" class="form-control" name="account" required>
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="form-group">
                        <label>状态</label>
                        <select class="form-control" name="status">
                            <option value="1">启用</option>
                            <option value="0">禁用</option>
                        </select>
                    </div>
                    <div class="text-right">
                        <button type="button" class="btn btn-secondary mr-2" data-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function deleteUser(id) {
        if (!confirm('确定要删除吗？')) {
            return;
        }
        var ctx = '${pageContext.request.contextPath}';
        $.post(ctx + '/user/deleteJson/' + id, function (res) {
            if ((res.code && res.code === 200) || res.success) {
                alert(res.msg || '删除成功');
                location.reload();
            } else {
                alert(res.msg || res.message || '删除失败');
            }
        }).fail(function () {
            alert('服务器异常，删除失败');
        });
    }
</script>
</body>
</html>