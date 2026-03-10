<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>请假申请</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .card { margin: 60px auto; max-width: 600px; }
        .btn-primary { background: #2196f3; border: none; border-radius: 6px; }
        .btn-primary:hover { background: #1976d2; }
        .img-preview { max-width: 100px; max-height: 100px; margin-right: 10px; }
    </style>
</head>
<body>
<div class="container">
    <div class="card p-4 shadow">
        <h3 class="mb-4 text-center">请假申请</h3>
        <form action="${pageContext.request.contextPath}/leave/add" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>请假类型</label>
                <select class="form-control" name="leaveTypeCode" required>
                    <option value="事假">事假</option>
                    <option value="病假">病假</option>
                    <option value="年假">年假</option>
                    <option value="调休">调休</option>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>开始时间</label>
                    <input type="datetime-local" class="form-control" name="leaveStartTime" required>
                </div>
                <div class="form-group col-md-6">
                    <label>结束时间</label>
                    <input type="datetime-local" class="form-control" name="leaveEndTime" required>
                </div>
            </div>
            <div class="form-group">
                <label>时长（小时）</label>
                <input type="number" class="form-control" name="duration" min="1" required>
            </div>
            <div class="form-group">
                <label>请假事由</label>
                <textarea class="form-control" name="leaveReason" rows="3" maxlength="200" required></textarea>
            </div>
            <div class="form-group">
                <label>图片上传（可选）</label>
                <input type="file" class="form-control-file" name="imageFile" accept="image/*" onchange="previewImg(event)">
                <div id="imgPreview" class="mt-2"></div>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary px-5">提交申请</button>
            </div>
        </form>
    </div>
</div>
<script>
function previewImg(event) {
    var files = event.target.files;
    var preview = document.getElementById('imgPreview');
    preview.innerHTML = '';
    if (files && files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var img = document.createElement('img');
            img.src = e.target.result;
            img.className = 'img-preview';
            preview.appendChild(img);
        };
        reader.readAsDataURL(files[0]);
    }
}
</script>
</body>
</html> 