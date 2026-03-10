<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
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
        <div>
            <h3 class="mb-0">员工列表</h3>
            <small class="text-muted">管理员端 · 查看与管理所有在职/离职员工信息</small>
        </div>
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addEmployeeModal">
            添加员工
        </button>
    </div>
    <form class="form-inline search-bar" method="get" action="${pageContext.request.contextPath}/employee/page">
        <input type="text" class="form-control mr-2" name="name" value="${name}" placeholder="按姓名搜索员工"/>
        <button type="submit" class="btn btn-primary mr-2">搜索</button>
        <a href="${pageContext.request.contextPath}/employee/page" class="btn btn-light btn-sm border">重置</a>
    </form>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-sm">
            <thead>
            <tr>
                <th class="d-none">ID</th>
                <th>姓名</th>
                <th class="d-none">工号</th>
                <th>入职日期</th>
                <th>角色类型</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="emp" items="${employees}">
                <tr>
                    <td class="d-none">${emp.id}</td>
                    <td>${emp.name}</td>
                    <td class="d-none">${emp.code}</td>
                    <td>${emp.entryDate}</td>
                    <td>${emp.roleType}</td>
                    <td>${emp.status}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/employee/edit/${emp.id}" class="btn btn-sm btn-primary" target="mainFrame">编辑</a>
                        <button type="button" class="btn btn-sm btn-danger" onclick="deleteEmployee(${emp.id})">删除</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <!-- 分页按钮 -->
    <c:set var="baseUrl" value="${pageContext.request.contextPath}/employee/page"/>
    <c:set var="query" value="name=${name}"/>
    <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
</div>

<!-- 添加员工弹窗 -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="addEmployeeModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addEmployeeModalLabel">添加员工</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/employee/add" method="post">
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>姓名</label>
                            <input type="text" class="form-control" name="name" required/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>工号</label>
                            <input type="text" class="form-control" name="code"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>邮箱</label>
                            <input type="email" class="form-control" name="email"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>手机号</label>
                            <input type="text" class="form-control" name="mobile"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>身份证号</label>
                            <input type="text" class="form-control" name="idCard"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>出生日期</label>
                            <input type="date" class="form-control" name="birthday"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>性别</label>
                            <input type="number" class="form-control" name="sex"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>民族</label>
                            <input type="text" class="form-control" name="nationCode"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>政治面貌</label>
                            <input type="text" class="form-control" name="politicalCode"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>籍贯</label>
                            <input type="text" class="form-control" name="nativePlace"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>毕业院校</label>
                            <input type="text" class="form-control" name="graduateSchool"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>专业</label>
                            <input type="text" class="form-control" name="majorCode"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>最高学历</label>
                            <input type="text" class="form-control" name="highestEducationCode"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>最高学位</label>
                            <input type="text" class="form-control" name="highestDegreeCode"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>现居住地</label>
                            <input type="text" class="form-control" name="habitation"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>婚姻状态</label>
                            <input type="number" class="form-control" name="maritalStatus"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>入职日期</label>
                            <input type="date" class="form-control" name="entryDate"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>离职日期</label>
                            <input type="date" class="form-control" name="leaveDate"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>部门ID</label>
                            <input type="number" class="form-control" name="deptId"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>岗位岗级ID</label>
                            <input type="number" class="form-control" name="postLevelId"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>用户ID</label>
                            <input type="number" class="form-control" name="userId"/>
                        </div>
                        <div class="form-group col-md-6">
                            <label>角色类型</label>
                            <input type="number" class="form-control" name="roleType"/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>状态</label>
                            <input type="number" class="form-control" name="status"/>
                        </div>
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
    function deleteEmployee(id) {
        if (!confirm('确定要删除该员工吗？')) {
            return;
        }
        var ctx = '${pageContext.request.contextPath}';
        $.post(ctx + '/employee/deleteJson/' + id, function (res) {
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
