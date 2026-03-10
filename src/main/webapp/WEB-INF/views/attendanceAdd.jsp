<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加考勤记录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:500px;">
    <h3 class="mb-4">添加考勤记录</h3>
    <form action="${pageContext.request.contextPath}/attendance/add" method="post">
        <div class="form-group">
            <label>用户ID</label>
            <input type="number" class="form-control" name="userId" required />
        </div>
        <div class="form-group">
            <label>员工姓名</label>
            <input type="text" class="form-control" name="userName" required />
        </div>
        <div class="form-group">
            <label>考勤日期</label>
            <input type="date" class="form-control" name="attendanceDate" required />
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>签到时间</label>
                <input type="time" class="form-control" name="checkInTime" id="checkInTime" />
            </div>
            <div class="form-group col-md-6">
                <label>签退时间</label>
                <input type="time" class="form-control" name="checkOutTime" id="checkOutTime" />
            </div>
        </div>
        <div class="form-group">
            <label>状态</label>
            <select class="form-control" name="status" id="statusSelect" required>
                <option value="0">正常</option>
                <option value="1">迟到</option>
                <option value="2">早退</option>
                <option value="3">缺勤</option>
            </select>
        </div>
        <div class="form-group">
            <label>备注</label>
            <textarea class="form-control" name="remark" rows="2"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">提交</button>
        <a href="${pageContext.request.contextPath}/attendance/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
$(function(){
   function toggleTime(){
       var val = $('#statusSelect').val();
       if(val==='3'){
           $('#checkInTime,#checkOutTime').val('').prop('disabled',true).prop('required',false);
       }else{
           $('#checkInTime,#checkOutTime').prop('disabled',false).prop('required',true);
       }
   }
   $('#statusSelect').on('change',toggleTime);
   toggleTime(); // 初始调用
});
</script>
</body>
</html> 