<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>岗位列表</title>
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
        <h3 class="mb-0">岗位列表</h3>
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addPostLevelModal">
            添加岗位
        </button>
    </div>
    <form class="form-inline search-bar" method="get" action="${pageContext.request.contextPath}/postlevel/page">
        <input type="text" class="form-control mr-2" name="name" value="${name}" placeholder="岗位名称"/>
        <button type="submit" class="btn btn-primary">搜索</button>
    </form>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-sm">
            <thead>
            <tr>
                <th class="d-none">ID</th>
                <th>名称</th>
                <th>岗级</th>
                <th>工资</th>
                <th>排序码</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="pl" items="${postLevels}">
                <tr>
                    <td class="d-none">${pl.id}</td>
                    <td>${pl.name}</td>
                    <td>${pl.level}</td>
                    <td>${pl.salary}</td>
                    <td>${pl.sortCode}</td>
                    <td>${pl.status}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/postlevel/edit/${pl.id}" class="btn btn-sm btn-primary" target="mainFrame">编辑</a>
                        <button type="button" class="btn btn-sm btn-danger" onclick="deletePostLevel(${pl.id})">删除</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 分页按钮 -->
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/postlevel/page"/>
    <c:set var="query" value="name=${name}"/>
    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
</div>

<!-- 添加岗位弹窗 -->
<div class="modal fade" id="addPostLevelModal" tabindex="-1" role="dialog" aria-labelledby="addPostLevelModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addPostLevelModalLabel">添加岗位</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/postlevel/add" method="post">
                    <div class="form-group">
                        <label>岗位名称</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>岗位级别</label>
                        <input type="text" class="form-control" name="level">
                    </div>
                    <div class="form-group">
                        <label>薪资</label>
                        <input type="number" class="form-control" name="salary">
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
    function deletePostLevel(id) {
        if (!confirm('确定要删除吗？')) {
            return;
        }
        var ctx = '${pageContext.request.contextPath}';
        $.post(ctx + '/postlevel/deleteJson/' + id, function (res) {
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