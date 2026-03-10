<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统测试</title>
    <link href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Microsoft YaHei', sans-serif;
            padding: 20px;
        }
        
        .test-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .test-button {
            margin: 5px;
            min-width: 120px;
        }
        
        .result-area {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
            max-height: 400px;
            overflow-y: auto;
        }
        
        .success {
            color: #28a745;
        }
        
        .error {
            color: #dc3545;
        }
        
        .info {
            color: #17a2b8;
        }
        
        pre {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="test-card">
            <h4 class="mb-4">系统功能测试</h4>
            
            <div class="row">
                <div class="col-md-6">
                    <h6>基础功能测试</h6>
                    <button class="btn btn-primary test-button" onclick="testDatabase()">数据库连接</button>
                    <button class="btn btn-success test-button" onclick="testSpring()">Spring配置</button>
                    <button class="btn btn-info test-button" onclick="testLogin()">登录功能</button>
                    <button class="btn btn-warning test-button" onclick="testSystemInfo()">系统信息</button>
                </div>
                
                <div class="col-md-6">
                    <h6>批量测试</h6>
                    <button class="btn btn-secondary test-button" onclick="runAllTests()">运行所有测试</button>
                    <button class="btn btn-light test-button" onclick="clearResults()">清空结果</button>
                </div>
            </div>
            
            <div class="result-area" id="testResults">
                <p class="text-muted">点击上方按钮开始测试...</p>
            </div>
        </div>
        
        <div class="test-card">
            <h6>测试说明</h6>
            <ul>
                <li><strong>数据库连接</strong>：测试与MySQL数据库的连接状态和用户数据查询</li>
                <li><strong>Spring配置</strong>：验证Spring容器和依赖注入是否正常工作</li>
                <li><strong>登录功能</strong>：测试用户登录验证功能</li>
                <li><strong>系统信息</strong>：显示系统运行环境和配置信息</li>
            </ul>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/jquery-3.6.1.js"></script>
    
    <script>
        function addResult(message, type = 'info') {
            var timestamp = new Date().toLocaleTimeString();
            var className = type;
            var icon = type === 'success' ? '✓' : type === 'error' ? '✗' : 'ℹ';
            
            var html = '<div class="' + className + '">' +
                      '<strong>[' + timestamp + '] ' + icon + '</strong> ' + message +
                      '</div>';
            
            $('#testResults').append(html);
            $('#testResults').scrollTop($('#testResults')[0].scrollHeight);
        }
        
        function testDatabase() {
            addResult('开始测试数据库连接...');
            
            $.ajax({
                url: '${pageContext.request.contextPath}/test/db',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        addResult('数据库连接成功！用户数量: ' + response.data.userCount, 'success');
                        addResult('用户列表: ' + JSON.stringify(response.data.users, null, 2));
                    } else {
                        addResult('数据库连接失败: ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addResult('数据库测试请求失败: ' + error, 'error');
                }
            });
        }
        
        function testSpring() {
            addResult('开始测试Spring配置...');
            
            $.ajax({
                url: '${pageContext.request.contextPath}/test/spring',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        addResult('Spring配置正常！', 'success');
                        addResult('UserMapper注入状态: ' + response.data.userMapper, 'success');
                    } else {
                        addResult('Spring配置测试失败: ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addResult('Spring测试请求失败: ' + error, 'error');
                }
            });
        }
        
        function testLogin() {
            addResult('开始测试登录功能...');
            
            $.ajax({
                url: '${pageContext.request.contextPath}/test/login',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        addResult('登录功能测试完成！', 'success');
                        addResult('管理员账户: ' + (response.data.adminFound ? '✓ 正常' : '✗ 异常'), 
                                response.data.adminFound ? 'success' : 'error');
                        addResult('普通用户账户: ' + (response.data.userFound ? '✓ 正常' : '✗ 异常'), 
                                response.data.userFound ? 'success' : 'error');
                        
                        if (response.data.adminName) {
                            addResult('管理员姓名: ' + response.data.adminName);
                        }
                        if (response.data.userName) {
                            addResult('用户姓名: ' + response.data.userName);
                        }
                    } else {
                        addResult('登录功能测试失败: ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addResult('登录测试请求失败: ' + error, 'error');
                }
            });
        }
        
        function testSystemInfo() {
            addResult('开始获取系统信息...');
            
            $.ajax({
                url: '${pageContext.request.contextPath}/test/info',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        addResult('系统信息获取成功！', 'success');
                        var info = response.data;
                        addResult('项目名称: ' + info.projectName);
                        addResult('版本: ' + info.version);
                        addResult('框架: ' + info.framework);
                        addResult('Java版本: ' + info.javaVersion);
                        addResult('操作系统: ' + info.osName);
                        addResult('服务器时间: ' + info.serverTime);
                    } else {
                        addResult('系统信息获取失败: ' + response.message, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    addResult('系统信息请求失败: ' + error, 'error');
                }
            });
        }
        
        function runAllTests() {
            clearResults();
            addResult('开始运行所有测试...', 'info');
            
            setTimeout(function() { testDatabase(); }, 500);
            setTimeout(function() { testSpring(); }, 1500);
            setTimeout(function() { testLogin(); }, 2500);
            setTimeout(function() { testSystemInfo(); }, 3500);
            setTimeout(function() { 
                addResult('所有测试完成！', 'success'); 
            }, 4500);
        }
        
        function clearResults() {
            $('#testResults').html('<p class="text-muted">测试结果已清空...</p>');
        }
    </script>
</body>
</html> 