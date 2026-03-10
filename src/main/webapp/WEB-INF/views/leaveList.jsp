<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>请假记录列表</title>
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
        <h3 class="mb-0">请假记录列表</h3>
        <c:if test="${!sessionScope.isAdmin}">
            <a href="${pageContext.request.contextPath}/leave/add" class="btn btn-primary">添加请假</a>
        </c:if>
    </div>

    <!-- 分类标签：未批准 / 已批准 / 全部记录 -->
    <ul class="nav nav-pills mb-3" id="leaveTabs">
        <li class="nav-item">
            <a class="nav-link active" href="javascript:void(0);" data-filter="pending">未批准列表</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="javascript:void(0);" data-filter="approved">已批准列表</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="javascript:void(0);" data-filter="all">请假记录</a>
        </li>
    </ul>
    <form class="form-inline search-bar" method="get" action="${pageContext.request.contextPath}/leave/page">
        <input type="text" class="form-control mr-2" name="employeeName" value="${employeeName}" placeholder="员工姓名"/>
        <button type="submit" class="btn btn-primary">搜索</button>
    </form>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-sm">
            <thead>
            <tr>
                <th class="d-none">ID</th>
                <th class="d-none">用户ID</th>
                <th>姓名</th>
                <th>请假类型</th>
                <th>开始时间</th>
                <th>结束时间</th>
                <th>事由</th>
                <th>状态</th>
                <c:if test="${sessionScope.isAdmin}">
                    <th>操作</th>
                </c:if>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="rec" items="${records}">
                <tr data-status="${rec.status}">
                    <td class="d-none">${rec.id}</td>
                    <td class="d-none">${rec.userId}</td>
                    <td>${rec.userName}</td>
                    <td>${rec.leaveTypeCode}</td>
                    <td>${rec.leaveStartTime}</td>
                    <td>${rec.leaveEndTime}</td>
                    <td>${rec.leaveReason}</td>
                    <td>
                      <c:choose>
                        <c:when test="${sessionScope.isAdmin}">
                          <select class="form-control form-control-sm" data-id="${rec.id}">
                            <option value="1" ${rec.status==1?'selected':''}>待审核</option>
                            <option value="2" ${rec.status==2?'selected':''}>审批通过</option>
                            <option value="3" ${rec.status==3?'selected':''}>驳回</option>
                          </select>
                        </c:when>
                        <c:otherwise>
                          <c:choose>
                            <c:when test="${rec.status==1}">待审核</c:when>
                            <c:when test="${rec.status==2}">审批通过</c:when>
                            <c:when test="${rec.status==3}">驳回</c:when>
                            <c:otherwise>未知</c:otherwise>
                          </c:choose>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <c:if test="${sessionScope.isAdmin}">
                        <td>
                            <button type="button" class="btn btn-sm btn-danger" onclick="deleteLeave(${rec.id})">删除</button>
                        </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 分页按钮 -->
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/leave/page"/>
    <c:set var="query" value="employeeName=${employeeName}"/>
    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
    <!-- 保存按钮 -->
    <c:if test="${sessionScope.isAdmin}">
      <div class="mt-2 text-right">
        <button id="saveBtn" class="btn btn-primary btn-sm">保存修改</button>
      </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
$(function(){
  // 分类筛选
  function applyFilter(type){
    $('tbody tr').show();
    if(type==='pending'){
      // 未审批：只显示 待审核(1)
      $('tbody tr').filter(function(){return $(this).data('status')!=1;}).hide();
    }else if(type==='approved'){
      // 已审批：包含 通过(2) 和 驳回(3)
      $('tbody tr').filter(function(){return $(this).data('status')==1;}).hide();
    }
  }
  $('#leaveTabs a').on('click',function(){
    $('#leaveTabs a').removeClass('active');
    $(this).addClass('active');
    applyFilter($(this).data('filter'));
  });
  // 默认显示未批准列表
  applyFilter('pending');

  $('#saveBtn').on('click',function(){
    var arr=[];
    $('select[data-id].changed').each(function(){
      arr.push({id:$(this).data('id'),status:$(this).val()});
    });
    if(arr.length===0){alert('没有修改');return;}
    $.ajax({
      url:'${pageContext.request.contextPath}/leave/batch-status',
      type:'POST',
      contentType:'application/json',
      data:JSON.stringify(arr),
      success:function(res){
        if(res.code===200){
          alert('保存成功');
          $('select.changed').removeClass('changed');
        }else{
          alert(res.msg);
        }
      },
      error:function(){alert('服务器错误');}
    });
  });
  // 标记已修改
  $('body').on('change','select[data-id]',function(){ $(this).addClass('changed'); });

  // 管理员删除请假记录
  window.deleteLeave = function(id){
    if(!confirm('确定要删除该请假记录吗？')) return;
    $.post('${pageContext.request.contextPath}/leave/deleteJson/' + id,function(res){
      if((res.code && res.code===200) || res.success){
        alert(res.msg || '删除成功');
        location.reload();
      }else{
        alert(res.msg || res.message || '删除失败');
      }
    }).fail(function(){ alert('服务器异常，删除失败'); });
  };
});
</script>
</body>
</html> 