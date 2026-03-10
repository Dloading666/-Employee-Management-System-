<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>公告管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container card mt-4 p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">公告管理</h3>
        <button class="btn btn-primary btn-sm" disabled>+ 新建公告（示例，占位）</button>
    </div>
    <p class="text-muted">当前为示例页面，后续可以接入公告表，实现发布、编辑、查看历史记录等功能。</p>
    <table class="table table-bordered table-hover table-sm mt-3">
        <thead class="thead-light">
        <tr>
            <th style="width: 60px;">ID</th>
            <th>标题</th>
            <th style="width: 160px;">发布时间</th>
            <th style="width: 120px;">发布人</th>
            <th style="width: 120px;">状态</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>1</td>
            <td>示例公告：本月工资发放时间调整</td>
            <td>2026-03-05 10:00</td>
            <td>管理员</td>
            <td><span class="badge badge-success">已发布</span></td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>

{
  "cells": [],
  "metadata": {
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 2
}