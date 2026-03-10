<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>编辑考勤记录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">编辑考勤记录</h3>
    <form action="${pageContext.request.contextPath}/attendance/edit" method="post">
        <input type="hidden" name="id" value="${attendance.id}" />
        <div class="form-group">
            <label>用户ID</label>
            <input type="number" class="form-control" name="userId" value="${attendance.userId}" required />
        </div>
        <div class="form-group">
            <label>员工姓名</label>
            <input type="text" class="form-control" name="userName" value="${attendance.userName}" required />
        </div>
        <div class="form-group">
            <label>考勤日期</label>
            <input type="date" class="form-control" name="attendanceDate" value="${attendance.attendanceDate}" required />
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>签到时间</label>
                <input type="time" class="form-control" name="checkInTime" value="${attendance.checkInTime}" required />
            </div>
            <div class="form-group col-md-6">
                <label>签退时间</label>
                <input type="time" class="form-control" name="checkOutTime" value="${attendance.checkOutTime}" required />
            </div>
        </div>
        <div class="form-group">
            <label>状态</label>
            <select class="form-control" name="status" required>
                <option value="0" ${attendance.status==0?'selected':''}>正常</option>
                <option value="1" ${attendance.status==1?'selected':''}>迟到</option>
                <option value="2" ${attendance.status==2?'selected':''}>早退</option>
                <option value="3" ${attendance.status==3?'selected':''}>缺勤</option>
            </select>
        </div>
        <div class="form-group">
            <label>备注</label>
            <textarea class="form-control" name="remark" rows="2">${attendance.remark}</textarea>
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/attendance/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
</body>
</html> 