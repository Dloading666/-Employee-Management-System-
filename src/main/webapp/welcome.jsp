<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统首页</title>
    <link href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Microsoft YaHei', sans-serif;
            padding: 20px;
        }
        
        .welcome-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .quick-action {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .quick-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        
        .quick-action i {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .system-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
        }
        
        .feature-list li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .feature-list li:last-child {
            border-bottom: none;
        }
        
        .feature-list li::before {
            content: "✓";
            color: #28a745;
            font-weight: bold;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <!-- 欢迎信息 -->
        <div class="welcome-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-3">欢迎使用企业员工管理系统</h2>
                    <p class="text-muted mb-0">

                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <div class="system-info">
                        <h5>系统信息</h5>
                        <p class="mb-1">版本：v1.0.0</p>

                        <p class="mb-0">当前时间：<span id="currentTime"></span></p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 统计数据 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number text-primary" id="totalUsers">-</div>
                    <div class="stat-label">系统用户</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number text-success" id="totalEmployees">-</div>
                    <div class="stat-label">在职员工</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number text-warning" id="totalDepartments">-</div>
                    <div class="stat-label">部门数量</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card">
                    <div class="stat-number text-info" id="todayAttendance">-</div>
                    <div class="stat-label">今日考勤</div>
                </div>
            </div>
        </div>

        <!-- 图表分析 -->
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="welcome-card">
                    <h5 class="mb-3 text-center">新增人数 & 请假人数（近6个月）</h5>
                    <div id="trendBar" style="height:280px;"></div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="welcome-card">
                    <h5 class="mb-3 text-center">部门人数比例</h5>
                    <div id="deptPie" style="height:280px;"></div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="welcome-card">
                    <h5 class="mb-3 text-center">今日考勤状态</h5>
                    <div id="attPie" style="height:280px;"></div>
                </div>
            </div>
        </div>

        <!-- 快捷操作、系统功能区块已移除 -->

        <!-- 使用说明区块已移除 -->
    </div>

    <script src="${pageContext.request.contextPath}/static/jquery-3.6.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // 更新当前时间
            function updateTime() {
                var now = new Date();
                var timeString = now.getFullYear() + '-' + 
                    String(now.getMonth() + 1).padStart(2, '0') + '-' + 
                    String(now.getDate()).padStart(2, '0') + ' ' +
                    String(now.getHours()).padStart(2, '0') + ':' + 
                    String(now.getMinutes()).padStart(2, '0') + ':' + 
                    String(now.getSeconds()).padStart(2, '0');
                $('#currentTime').text(timeString);
            }
            
            // 每秒更新时间
            updateTime();
            setInterval(updateTime, 1000);
            
            // 加载统计数据
            loadStatistics();
            // 每60秒刷新一次
            setInterval(loadStatistics,60000);
            initCharts();
            // 每5分钟刷新图表
            setInterval(initCharts,300000);
        });
        
        function loadStatistics() {
            $.get('${pageContext.request.contextPath}/stats/summary',function(res){
                if(res.code===200){
                   var d=res.data;
                   $('#totalUsers').text(d.userCount);
                   $('#totalEmployees').text(d.employeeCount);
                   $('#totalDepartments').text(d.departmentCount);
                   $('#todayAttendance').text(d.todayAttendance);
                }else{
                   console.error(res.msg);
                }
            });
        }

        function initCharts(){
            loadTrendChart();
            loadDeptChart();
            loadAttChart();
        }

        function loadTrendChart(){
            $.get('${pageContext.request.contextPath}/stats/add-leave-trend',function(res){
                if(res.code===200){
                    var dom=document.getElementById('trendBar');
                    var chart=echarts.init(dom);
                    var option={
                        tooltip:{trigger:'axis'},
                        legend:{data:['新增','请假']},
                        xAxis:{type:'category',data:res.data.months},
                        yAxis:{type:'value'},
                        series:[
                            {name:'新增',type:'bar',data:res.data.add,itemStyle:{color:'#4caf50'}},
                            {name:'请假',type:'bar',data:res.data.leave,itemStyle:{color:'#ff9800'}}
                        ]
                    };
                    chart.setOption(option);
                }
            });
        }

        function loadDeptChart(){
            $.get('${pageContext.request.contextPath}/stats/dept-employee',function(res){
                if(res.code===200){
                    var dom=document.getElementById('deptPie');
                    var chart=echarts.init(dom);
                    var option={
                        tooltip:{trigger:'item',formatter:'{b}: {c}人 ({d}%)'},
                        legend:{type:'scroll',orient:'vertical',left:0,top:'middle'},
                        series:[{
                            type:'pie',
                            center:['65%','50%'],
                            radius:['40%','65%'],
                            avoidLabelOverlap:false,
                            label:{
                                show:true,
                                formatter:'{b}\n{d}%'
                            },
                            labelLine:{
                                show:true,
                                length:18,
                                length2:12
                            },
                            data:res.data,
                            emphasis:{itemStyle:{shadowBlur:10,shadowOffsetX:0,shadowColor:'rgba(0,0,0,0.5)'}}
                        }]
                    };
                    chart.setOption(option);
                }
            });
        }

        function loadAttChart(){
            $.get('${pageContext.request.contextPath}/stats/attendance-status',function(res){
                if(res.code===200){
                    var dom=document.getElementById('attPie');
                    var chart=echarts.init(dom);
                    var option={
                        tooltip:{trigger:'item'},
                        series:[{type:'pie',radius:['40%','70%'],data:res.data,label:{formatter:'{b}: {d}%'}}]
                    };
                    chart.setOption(option);
                }
            });
        }
    </script>
</body>
</html> 