<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>考勤记录列表</title>
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
    <c:set var="isAdmin" value="${sessionScope.isAdmin}"/>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">考勤记录列表</h3>
        <c:choose>
            <c:when test="${isAdmin}">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addAttendanceModal">
                    添加考勤
                </button>
            </c:when>
            <c:otherwise>
                <div>
                    <button type="button" id="checkInBtn" class="btn btn-primary mr-2">签到</button>
                    <button type="button" id="checkOutBtn" class="btn btn-primary">签退</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <form class="form-inline search-bar" method="get" action="${pageContext.request.contextPath}/attendance/page">
        <input type="text" class="form-control mr-2" name="employeeName" value="${employeeName}" placeholder="员工姓名"/>
        <button type="submit" class="btn btn-primary">搜索</button>
    </form>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-sm">
            <thead>
            <tr>
                <th class="d-none">ID</th>
                <th class="d-none">用户ID</th>
                <th>员工姓名</th>
                <th>考勤日期</th>
                <th>签到时间</th>
                <th>签退时间</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="rec" items="${records}">
                <tr>
                    <td class="d-none">${rec.id}</td>
                    <td class="d-none">${rec.userId}</td>
                    <td>${rec.userName}</td>
                    <td>${rec.attendanceDate}</td>
                    <td>${rec.checkInTime}</td>
                    <td>${rec.checkOutTime}</td>
                    <td><c:choose>
                         <c:when test="${rec.status == 0}">正常</c:when>
                         <c:when test="${rec.status == 1}">迟到</c:when>
                         <c:when test="${rec.status == 2}">早退</c:when>
                         <c:when test="${rec.status == 3}">缺勤</c:when>
                         <c:otherwise>未知</c:otherwise>
                    </c:choose></td>
                    <td>
                        <c:if test="${isAdmin}">
                            <a href="${pageContext.request.contextPath}/attendance/edit/${rec.id}" class="btn btn-sm btn-primary">编辑</a>
                            <button type="button" class="btn btn-sm btn-danger" onclick="deleteAttendance(${rec.id})">删除</button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 分页按钮 -->
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/attendance/page"/>
    <c:set var="query" value="employeeName=${employeeName}"/>
    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
</div>

<!-- 添加考勤弹窗（管理员使用） -->
<div class="modal fade" id="addAttendanceModal" tabindex="-1" role="dialog" aria-labelledby="addAttendanceModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addAttendanceModalLabel">添加考勤记录</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
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
                    <div class="text-right">
                        <button type="button" class="btn btn-secondary mr-2" data-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">提交</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(function(){
        var ctx = '${pageContext.request.contextPath}';
        $('#checkInBtn').click(function(){
            $.post(ctx + '/attendance/check-in', function(res){
                if(res.code === 200){
                    alert(res.msg);
                    location.reload();
                }else{
                    alert(res.msg);
                }
            })
        });
        $('#checkOutBtn').click(function(){
            $.post(ctx + '/attendance/check-out', function(res){
                if(res.code === 200){
                    alert(res.msg);
                    location.reload();
                }else{
                    alert(res.msg);
                }
            })
        });

        // 管理员添加考勤时，根据状态启用/禁用时间
        function toggleTime(){
            var val = $('#statusSelect').val();
            if(val==='3'){
                $('#checkInTime,#checkOutTime').val('').prop('disabled',true).prop('required',false);
            }else{
                $('#checkInTime,#checkOutTime').prop('disabled',false).prop('required',true);
            }
        }
        $('#statusSelect').on('change',toggleTime);
        toggleTime();

        window.deleteAttendance = function(id){
            if(!confirm('确定删除吗？')){ return; }
            $.post(ctx + '/attendance/deleteJson/' + id, function(res){
                if((res.code && res.code===200) || res.success){
                    alert(res.msg || '删除成功');
                    location.reload();
                }else{
                    alert(res.msg || res.message || '删除失败');
                }
            }).fail(function(){
                alert('服务器异常，删除失败');
            });
        };
    });
</script>
</body>
</html> 