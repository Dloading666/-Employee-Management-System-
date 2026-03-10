<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>编辑请假记录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">编辑请假记录</h3>
    <form action="${pageContext.request.contextPath}/leave/edit" method="post">
        <input type="hidden" name="id" value="${leave.id}" />
        <div class="form-group">
            <label>用户ID</label>
            <input type="number" class="form-control" name="userId" value="${leave.userId}" required />
        </div>
        <div class="form-group">
            <label>请假类型</label>
            <input type="text" class="form-control" name="leaveTypeCode" value="${leave.leaveTypeCode}" required />
        </div>
        <div class="form-group">
            <label>开始时间</label>
            <input type="datetime-local" class="form-control" name="leaveStartTime" value="${leave.leaveStartTime}" required />
        </div>
        <div class="form-group">
            <label>结束时间</label>
            <input type="datetime-local" class="form-control" name="leaveEndTime" value="${leave.leaveEndTime}" required />
        </div>
        <div class="form-group">
            <label>事由</label>
            <input type="text" class="form-control" name="leaveReason" value="${leave.leaveReason}" required />
        </div>
        <div class="form-group">
            <label>状态</label>
            <select class="form-control" name="status" required>
                <option value="0" ${leave.status==0?'selected':''}>待提交</option>
                <option value="1" ${leave.status==1?'selected':''}>待审核</option>
                <option value="2" ${leave.status==2?'selected':''}>审批通过</option>
                <option value="3" ${leave.status==3?'selected':''}>驳回</option>
                <option value="9" ${leave.status==9?'selected':''}>销假</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/leave/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
</body>
</html> 