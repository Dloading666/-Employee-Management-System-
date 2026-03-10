<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>个人信息</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        body { background: #f5f7fb; }
        .profile-card { margin-top: 32px; border-radius: 12px; box-shadow: 0 6px 18px rgba(15,23,42,0.12); }
        .profile-header { background: linear-gradient(135deg,#4f46e5,#3b82f6); color: #fff; border-radius: 12px 12px 0 0; padding: 20px 24px; }
        .profile-header h3 { margin: 0; }
        .profile-body { padding: 24px; }
        .field-label { color: #6b7280; font-size: 13px; margin-bottom: 4px; }
        .field-value { font-size: 15px; font-weight: 500; color: #111827; }
        .field-input { display: none; }
        .section-title { font-size: 14px; font-weight: 600; color: #374151; margin-top: 12px; margin-bottom: 8px; }
        .readonly-field { color: #9ca3af; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
</head>
<body>
<div class="container">
    <div class="card profile-card">
        <div class="profile-header d-flex justify-content-between align-items-center">
            <div>
                <h3>个人信息</h3>
                <small>查看和编辑当前登录员工的详细资料</small>
            </div>
            <c:if test="${employee != null}">
                <button id="editBtn" class="btn btn-light btn-sm" onclick="toggleEditMode()">编辑</button>
                <button id="cancelBtn" class="btn btn-secondary btn-sm" onclick="cancelEdit()" style="display:none;">取消</button>
            </c:if>
        </div>
        <div class="profile-body">
            <c:if test="${employee == null}">
                <div class="alert alert-warning mb-4">
                    <h5>暂未找到与当前账号关联的员工信息</h5>
                    <p>您可以填写以下信息创建您的员工档案：</p>
                </div>
                <form id="createProfileForm" method="post" action="${pageContext.request.contextPath}/employee/createProfile">
                    <input type="hidden" name="userId" value="${currentUserId}" />
                    <div class="section-title">基本信息</div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="field-label">姓名 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">工号</label>
                            <input type="text" class="form-control" name="code" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">邮箱</label>
                            <input type="email" class="form-control" name="email" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="field-label">手机号</label>
                            <input type="text" class="form-control" name="mobile" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">性别</label>
                            <select class="form-control" name="sex">
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">出生日期</label>
                            <input type="date" class="form-control" name="birthday" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="field-label">现居住地</label>
                            <input type="text" class="form-control" name="habitation" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">婚姻状态</label>
                            <select class="form-control" name="maritalStatus">
                                <option value="1">已婚</option>
                                <option value="2">未婚</option>
                            </select>
                        </div>
                    </div>
                    <div class="section-title">学历信息</div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="field-label">毕业院校</label>
                            <input type="text" class="form-control" name="graduateSchool" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">专业</label>
                            <input type="text" class="form-control" name="majorCode" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="field-label">最高学历</label>
                            <input type="text" class="form-control" name="highestEducationCode" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="field-label">最高学位</label>
                            <input type="text" class="form-control" name="highestDegreeCode" />
                        </div>
                    </div>
                    <div class="text-right mt-4">
                        <button type="button" class="btn btn-primary" onclick="createProfile()">创建档案</button>
                    </div>
                </form>
            </c:if>
            <c:if test="${employee != null}">
                <form id="profileForm" method="post" action="${pageContext.request.contextPath}/employee/updateProfile">
                    <input type="hidden" name="id" value="${employee.id}" />
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="field-label">姓名</div>
                            <div class="field-value" id="name-display">${employee.name}</div>
                            <input type="text" class="form-control field-input" name="name" id="name-input" value="${employee.name}" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="field-label">工号</div>
                            <div class="field-value readonly-field">${employee.code}</div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="field-label">角色类型</div>
                            <div class="field-value readonly-field">${employee.roleType != null ? employee.roleType : '未设置'}</div>
                        </div>
                    </div>
                <div class="section-title">联系方式</div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="field-label">邮箱</div>
                        <div class="field-value" id="email-display">${empty employee.email ? '未填写' : employee.email}</div>
                        <input type="email" class="form-control field-input" name="email" id="email-input" value="${employee.email}" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">手机号</div>
                        <div class="field-value" id="mobile-display">${empty employee.mobile ? '未填写' : employee.mobile}</div>
                        <input type="text" class="form-control field-input" name="mobile" id="mobile-input" value="${employee.mobile}" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">现居住地</div>
                        <div class="field-value" id="habitation-display">${empty employee.habitation ? '未填写' : employee.habitation}</div>
                        <input type="text" class="form-control field-input" name="habitation" id="habitation-input" value="${employee.habitation}" />
                    </div>
                </div>
                <div class="section-title">基本信息</div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="field-label">性别</div>
                        <div class="field-value" id="sex-display">${employee.sex == 1 ? '男' : (employee.sex == 2 ? '女' : '未知')}</div>
                        <select class="form-control field-input" name="sex" id="sex-input">
                            <option value="1" ${employee.sex == 1 ? 'selected' : ''}>男</option>
                            <option value="2" ${employee.sex == 2 ? 'selected' : ''}>女</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">出生日期</div>
                        <div class="field-value" id="birthday-display">${employee.birthday != null ? employee.birthday : '未填写'}</div>
                        <input type="date" class="form-control field-input" name="birthday" id="birthday-input" value="${employee.birthday}" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">婚姻状态</div>
                        <div class="field-value" id="maritalStatus-display">${employee.maritalStatus == 1 ? '已婚' : (employee.maritalStatus == 2 ? '未婚' : '未知')}</div>
                        <select class="form-control field-input" name="maritalStatus" id="maritalStatus-input">
                            <option value="1" ${employee.maritalStatus == 1 ? 'selected' : ''}>已婚</option>
                            <option value="2" ${employee.maritalStatus == 2 ? 'selected' : ''}>未婚</option>
                        </select>
                    </div>
                </div>
                <div class="section-title">学历信息</div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="field-label">毕业院校</div>
                        <div class="field-value" id="graduateSchool-display">${empty employee.graduateSchool ? '未填写' : employee.graduateSchool}</div>
                        <input type="text" class="form-control field-input" name="graduateSchool" id="graduateSchool-input" value="${employee.graduateSchool}" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">专业</div>
                        <div class="field-value" id="majorCode-display">${empty employee.majorCode ? '未填写' : employee.majorCode}</div>
                        <input type="text" class="form-control field-input" name="majorCode" id="majorCode-input" value="${employee.majorCode}" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="field-label">最高学历/学位</div>
                        <div class="field-value" id="education-display">
                            ${empty employee.highestEducationCode ? '未填写' : employee.highestEducationCode} 
                            ${not empty employee.highestEducationCode && not empty employee.highestDegreeCode ? '/' : ''} 
                            ${empty employee.highestDegreeCode ? '' : employee.highestDegreeCode}
                        </div>
                        <div class="field-input">
                            <input type="text" class="form-control mb-2" name="highestEducationCode" placeholder="最高学历" value="${employee.highestEducationCode}" />
                            <input type="text" class="form-control" name="highestDegreeCode" placeholder="最高学位" value="${employee.highestDegreeCode}" />
                        </div>
                    </div>
                </div>
                <div class="section-title">工作信息</div>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <div class="field-label">部门</div>
                        <div class="field-value readonly-field">${deptName != null && deptName != '' ? deptName : (employee.deptId != null ? '部门ID: ' + employee.deptId : '未分配')}</div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="field-label">岗位</div>
                        <div class="field-value readonly-field">${postLevelName != null && postLevelName != '' ? postLevelName : (employee.postLevelId != null ? '岗位ID: ' + employee.postLevelId : '未分配')}</div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="field-label">入职日期</div>
                        <div class="field-value readonly-field">${employee.entryDate != null ? employee.entryDate : '未填写'}</div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="field-label">状态</div>
                        <div class="field-value">
                            <span class="badge ${employee.status == 1 ? 'badge-success' : 'badge-secondary'}">
                                ${employee.status == 1 ? '在职' : '离职'}
                            </span>
                        </div>
                    </div>
                </div>
                <div id="saveBtnContainer" style="display:none; margin-top: 20px; text-align: right;">
                    <button type="button" class="btn btn-primary" onclick="saveProfile()">保存</button>
                    <button type="button" class="btn btn-secondary ml-2" onclick="cancelEdit()">取消</button>
                </div>
                </form>
            </c:if>
        </div>
    </div>
</div>
<script>
var isEditMode = false;

function toggleEditMode() {
    isEditMode = !isEditMode;
    if (isEditMode) {
        // 显示输入框，隐藏显示值
        $('.field-value').not('.readonly-field').hide();
        $('.field-input').show();
        $('#editBtn').hide();
        $('#cancelBtn').show();
        $('#saveBtnContainer').show();
    } else {
        cancelEdit();
    }
}

function cancelEdit() {
    isEditMode = false;
    $('.field-value').show();
    $('.field-input').hide();
    $('#editBtn').show();
    $('#cancelBtn').hide();
    $('#saveBtnContainer').hide();
    // 恢复原始值
    location.reload();
}

function saveProfile() {
    if (!confirm('确定要保存修改吗？')) {
        return;
    }
    
    var formData = $('#profileForm').serialize();
    $.ajax({
        url: '${pageContext.request.contextPath}/employee/updateProfile',
        type: 'POST',
        data: formData,
        success: function(response) {
            if (response.code === 200 || response.success) {
                alert('保存成功');
                location.reload();
            } else {
                alert('保存失败：' + (response.msg || response.message || '未知错误'));
            }
        },
        error: function(xhr) {
            alert('保存失败：服务器错误');
            console.error(xhr);
        }
    });
}

function createProfile() {
    if (!confirm('确定要创建员工档案吗？')) {
        return;
    }
    
    var formData = $('#createProfileForm').serialize();
    $.ajax({
        url: '${pageContext.request.contextPath}/employee/createProfile',
        type: 'POST',
        data: formData,
        success: function(response) {
            if (response.code === 200 || response.success) {
                alert('创建成功');
                location.reload();
            } else {
                alert('创建失败：' + (response.msg || response.message || '未知错误'));
            }
        },
        error: function(xhr) {
            alert('创建失败：服务器错误');
            console.error(xhr);
        }
    });
}
</script>
</body>
</html>