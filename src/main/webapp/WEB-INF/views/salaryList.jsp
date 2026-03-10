<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>薪资发放记录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card mt-4 p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">薪资发放记录</h3>
        <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#addSalaryModal">+ 新建发放记录</button>
    </div>
    <table class="table table-bordered table-hover table-sm mt-3">
        <thead class="thead-light">
        <tr>
            <th class="d-none">ID</th>
            <th class="d-none">用户ID</th>
            <th>员工姓名</th>
            <th>发放月份</th>
            <th>金额</th>
            <th>备注</th>
            <th>发放时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="rec" items="${records}">
            <tr>
                <td class="d-none">${rec.id}</td>
                <td class="d-none">${rec.userId}</td>
                <td>${rec.userName}</td>
                <td>${rec.payMonth}</td>
                <td>${rec.amount}</td>
                <td>${rec.remark}</td>
                <td>${rec.createTime}</td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="deleteSalary('${rec.id}')">删除</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- 新建薪资记录弹窗 -->
<div class="modal fade" id="addSalaryModal" tabindex="-1" role="dialog" aria-labelledby="addSalaryModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addSalaryModalLabel">新建薪资记录</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/salary/add" method="post">
                    <div class="form-group">
                        <label>员工姓名</label>
                        <input type="text" class="form-control" name="userName" required>
                    </div>
                    <div class="form-group">
                        <label>发放月份（格式：2026-03）</label>
                        <input type="text" class="form-control" name="payMonth" placeholder="YYYY-MM" required>
                    </div>
                    <div class="form-group">
                        <label>金额</label>
                        <input type="number" step="0.01" class="form-control" name="amount" required>
                    </div>
                    <div class="form-group">
                        <label>备注</label>
                        <textarea class="form-control" name="remark" rows="2"></textarea>
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
    function deleteSalary(id) {
        if (!confirm('确定要删除该薪资记录吗？')) return;
        $.post('${pageContext.request.contextPath}/salary/deleteJson/' + id, function (res) {
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