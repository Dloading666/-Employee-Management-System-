<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>我的薪资</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card mt-4 p-4">
    <h3 class="mb-3">我的薪资</h3>
    <table class="table table-bordered table-hover table-sm">
        <thead class="thead-light">
        <tr>
            <th>发放月份</th>
            <th>金额</th>
            <th>备注</th>
            <th>发放时间</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="rec" items="${records}">
            <tr>
                <td>${rec.payMonth}</td>
                <td>${rec.amount}</td>
                <td>${rec.remark}</td>
                <td>${rec.createTime}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>

