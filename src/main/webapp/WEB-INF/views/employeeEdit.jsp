<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>编辑员工</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card p-4 mt-5" style="max-width:600px;">
    <h3 class="mb-4">编辑员工</h3>
    <form action="${pageContext.request.contextPath}/employee/edit" method="post" target="mainFrame">
        <input type="hidden" name="id" value="${employee.id}" />
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>姓名</label>
                <input type="text" class="form-control" name="name" value="${employee.name}" required />
            </div>
            <div class="form-group col-md-6">
                <label>工号</label>
                <input type="text" class="form-control" name="code" value="${employee.code}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>邮箱</label>
                <input type="email" class="form-control" name="email" value="${employee.email}" />
            </div>
            <div class="form-group col-md-6">
                <label>手机号</label>
                <input type="text" class="form-control" name="mobile" value="${employee.mobile}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>身份证号</label>
                <input type="text" class="form-control" name="idCard" value="${employee.idCard}" />
            </div>
            <div class="form-group col-md-6">
                <label>出生日期</label>
                <input type="date" class="form-control" name="birthday" value="${employee.birthday}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>性别</label>
                <input type="number" class="form-control" name="sex" value="${employee.sex}" />
            </div>
            <div class="form-group col-md-6">
                <label>民族</label>
                <input type="text" class="form-control" name="nationCode" value="${employee.nationCode}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>政治面貌</label>
                <input type="text" class="form-control" name="politicalCode" value="${employee.politicalCode}" />
            </div>
            <div class="form-group col-md-6">
                <label>籍贯</label>
                <input type="text" class="form-control" name="nativePlace" value="${employee.nativePlace}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>毕业院校</label>
                <input type="text" class="form-control" name="graduateSchool" value="${employee.graduateSchool}" />
            </div>
            <div class="form-group col-md-6">
                <label>专业</label>
                <input type="text" class="form-control" name="majorCode" value="${employee.majorCode}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>最高学历</label>
                <input type="text" class="form-control" name="highestEducationCode" value="${employee.highestEducationCode}" />
            </div>
            <div class="form-group col-md-6">
                <label>最高学位</label>
                <input type="text" class="form-control" name="highestDegreeCode" value="${employee.highestDegreeCode}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>现居住地</label>
                <input type="text" class="form-control" name="habitation" value="${employee.habitation}" />
            </div>
            <div class="form-group col-md-6">
                <label>婚姻状态</label>
                <input type="number" class="form-control" name="maritalStatus" value="${employee.maritalStatus}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>入职日期</label>
                <input type="date" class="form-control" name="entryDate" value="${employee.entryDate}" />
            </div>
            <div class="form-group col-md-6">
                <label>离职日期</label>
                <input type="date" class="form-control" name="leaveDate" value="${employee.leaveDate}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>部门ID</label>
                <input type="number" class="form-control" name="deptId" value="${employee.deptId}" />
            </div>
            <div class="form-group col-md-6">
                <label>岗位岗级ID</label>
                <input type="number" class="form-control" name="postLevelId" value="${employee.postLevelId}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>用户ID</label>
                <input type="number" class="form-control" name="userId" value="${employee.userId}" />
            </div>
            <div class="form-group col-md-6">
                <label>角色类型</label>
                <input type="number" class="form-control" name="roleType" value="${employee.roleType}" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label>状态</label>
                <input type="number" class="form-control" name="status" value="${employee.status}" />
            </div>
        </div>
        <button type="submit" class="btn btn-primary">保存</button>
        <a href="${pageContext.request.contextPath}/employee/list" class="btn btn-secondary ml-2">返回</a>
    </form>
</div>
<% if (request.getAttribute("editSuccess") != null) { %>
<script>
  window.parent.document.getElementById('mainFrame').src = '${pageContext.request.contextPath}/employee/list';
</script>
<% } %>
</body>
</html> 