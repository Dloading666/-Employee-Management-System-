# 员工管理系统 (Employee Management System)

一个基于 SSM（Spring + Spring MVC + MyBatis）框架开发的员工管理系统，支持管理员和普通员工两种角色，提供完整的员工信息管理、考勤管理、请假审批、薪资管理等功能。

## 📋 项目简介

本项目是一个企业级员工管理系统，采用前后端分离的设计理念，前端使用 JSP + Bootstrap + jQuery 实现，后端采用 Spring MVC + MyBatis 架构。系统支持双角色登录（管理员/员工），提供完整的员工信息管理、考勤记录、请假审批、薪资发放等功能模块。

### 主要功能

#### 管理员功能
- **员工管理**：员工信息的增删改查、员工档案管理
- **部门管理**：部门信息的增删改查、部门层级管理
- **岗位管理**：岗位信息的增删改查、岗位级别管理
- **用户管理**：系统用户的增删改查、用户状态管理
- **考勤管理**：考勤记录的添加、查询、删除
- **请假审批**：请假申请的审批（批准/驳回）、请假记录查询
- **薪资管理**：员工薪资发放记录的创建、查询、删除
- **公告管理**：系统公告的发布和管理
- **数据统计**：员工统计、考勤统计、部门统计等仪表盘数据

#### 员工功能
- **个人信息**：查看和编辑个人基本信息
- **我的考勤**：查看个人考勤记录
- **请假申请**：提交请假申请、查看请假状态
- **我的薪资**：查看个人薪资发放记录

## 🛠️ 技术栈

### 后端技术
- **Java**: JDK 17
- **Spring Framework**: 6.1.8
  - Spring MVC（Web层）
  - Spring JDBC（数据访问）
  - Spring Transaction（事务管理）
- **MyBatis**: 3.5.16
  - MyBatis-Spring: 3.0.3（Spring整合）
  - PageHelper: 5.3.1（分页插件）
- **数据库**: MySQL 8.0+
- **连接池**: Druid 1.2.23
- **构建工具**: Maven 3.x

### 前端技术
- **视图层**: JSP + JSTL
- **UI框架**: Bootstrap 4/5
- **JavaScript库**: 
  - jQuery 3.6.1
  - Layer（弹窗组件）
  - Bootstrap Table（表格组件）
  - Bootstrap DatePicker（日期选择器）
- **AJAX**: 用于异步数据交互

### 其他工具
- **日志**: Log4j 2.19.0
- **JSON处理**: Jackson 2.17.1
- **代码简化**: Lombok 1.18.34
- **服务器**: Apache Tomcat 10.1.28+

## 📁 项目结构

```
ssm_xml/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── edu/cqie/eams/
│   │   │       ├── controller/     # 控制器层
│   │   │       ├── service/        # 业务逻辑层
│   │   │       ├── mapper/        # MyBatis Mapper接口
│   │   │       ├── domain/        # 实体类
│   │   │       ├── comm/          # 公共类（RetJson等）
│   │   │       └── Interceptor/    # 拦截器（登录、权限）
│   │   ├── resources/
│   │   │   ├── applicationContext.xml  # Spring配置
│   │   │   ├── spring-mvc.xml          # Spring MVC配置
│   │   │   ├── mybatis-config.xml      # MyBatis配置
│   │   │   └── mapper/                 # MyBatis Mapper XML
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml        # Web应用配置
│   │       │   └── views/         # JSP视图文件
│   │       ├── static/            # 静态资源（CSS、JS、图片）
│   │       ├── main.jsp           # 管理员主页面
│   │       └── userMain.jsp       # 员工主页面
│   └── test/                      # 测试代码
├── sql代码.sql                    # 数据库初始化脚本
├── pom.xml                        # Maven依赖配置
└── README.md                      # 项目说明文档
```

## 🚀 快速开始

### 环境要求

- **JDK**: 17 或更高版本
- **Maven**: 3.6+ 
- **MySQL**: 8.0+ 
- **Tomcat**: 10.1+ 
- **IDE**: IntelliJ IDEA / Eclipse（推荐 IntelliJ IDEA）

### 数据库配置

1. **创建数据库**
   ```sql
   CREATE DATABASE `ems-db` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
   ```

2. **导入数据库脚本**
   - 使用 MySQL 客户端（如 Navicat、MySQL Workbench）执行项目根目录下的 `sql代码.sql` 文件
   - 或在命令行执行：
     ```bash
     mysql -u root -p ems-db < sql代码.sql
     ```

3. **修改数据库连接配置**
   
   编辑 `src/main/resources/applicationContext.xml`，修改数据库连接信息：
   ```xml
   <property name="url" value="jdbc:mysql://localhost:3306/ems-db?useUnicode=true&amp;characterEncoding=utf8&amp;useSSL=false&amp;serverTimezone=Asia/Shanghai"/>
   <property name="username" value="root"/>
   <property name="password" value="你的数据库密码"/>
   ```

### 项目启动

#### 方式一：使用 IDE（推荐）

1. **导入项目**
   - 使用 IntelliJ IDEA：`File` -> `Open` -> 选择项目目录
   - 等待 Maven 自动下载依赖

2. **配置 Tomcat**
   - 点击 `Run` -> `Edit Configurations`
   - 点击 `+` -> 选择 `Tomcat Server` -> `Local`
   - 在 `Deployment` 标签页添加 Artifact：`ssm:war exploded`
   - 设置 `Application context` 为 `/` 或 `/ssm`

3. **启动项目**
   - 点击运行按钮或按 `Shift + F10`
   - 等待 Tomcat 启动完成

4. **访问系统**
   - 浏览器访问：`http://localhost:8080/`
   - 默认会跳转到登录页面

#### 方式二：使用 Maven + Tomcat

1. **编译打包**
   ```bash
   mvn clean package
   ```

2. **部署到 Tomcat**
   - 将 `target/ssm.war` 复制到 Tomcat 的 `webapps` 目录
   - 启动 Tomcat：`bin/startup.bat`（Windows）或 `bin/startup.sh`（Linux/Mac）

3. **访问系统**
   - 浏览器访问：`http://localhost:8080/ssm/`

### 默认账号

#### 管理员账号
- **用户名**: `admin`
- **密码**: `123456`

#### 普通员工账号
- **用户名**: `lb`（刘备）
- **密码**: `123456`

其他测试账号请查看数据库 `sys_user` 表。

## 📝 功能说明

### 管理员模块

#### 1. 员工管理
- 查看员工列表（支持分页、搜索）
- 添加员工信息（模态框形式）
- 编辑员工信息
- 删除员工（AJAX方式，不跳转页面）
- 隐藏ID和工号列

#### 2. 部门管理
- 部门列表管理
- 添加/编辑/删除部门
- 隐藏ID、负责人ID、上级部门ID列

#### 3. 岗位管理
- 岗位列表管理
- 添加/编辑/删除岗位
- 隐藏ID列

#### 4. 用户管理
- 系统用户管理
- 用户状态管理（启用/禁用）
- 隐藏ID列

#### 5. 考勤管理
- 考勤记录查询
- 添加考勤记录（模态框）
- 删除考勤记录（AJAX）
- 隐藏ID和用户ID列

#### 6. 请假审批
- **未批准列表**：显示待审核和已驳回的请假申请
- **已批准列表**：显示已审批通过的请假记录
- **请假记录**：显示所有请假记录
- 审批操作（批准/驳回）
- 删除请假记录（AJAX）
- 隐藏ID和用户ID列

#### 7. 薪资管理
- 薪资发放记录管理
- 按员工姓名发放薪资（支持自动查找用户ID）
- 删除薪资记录（AJAX）
- 隐藏ID和用户ID列

#### 8. 公告管理
- 公告的发布和管理（待完善）

#### 9. 数据统计
- 员工总数统计
- 部门员工分布
- 考勤状态统计
- 请假趋势统计

### 员工模块

#### 1. 个人信息
- 查看个人详细信息
- 编辑个人信息（如果员工记录不存在，可自行创建）
- 显示部门、岗位等关联信息

#### 2. 我的考勤
- 查看个人考勤记录
- 考勤状态统计

#### 3. 请假申请
- 提交请假申请
- 查看请假审批状态

#### 4. 我的薪资
- 查看个人薪资发放记录
- 按月份查看薪资明细

## 🔧 配置说明

### 数据库配置

配置文件：`src/main/resources/applicationContext.xml`

```xml
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="url" value="jdbc:mysql://localhost:3306/ems-db?..."/>
    <property name="username" value="root"/>
    <property name="password" value="123456"/>
</bean>
```

### 拦截器配置

- **登录拦截器** (`LoginInterceptor`): 验证用户是否已登录
- **权限拦截器** (`PermissionInterceptor`): 验证管理员权限

配置文件：`src/main/resources/spring-mvc.xml`

### 分页配置

使用 PageHelper 插件，在 Mapper 方法前调用 `PageHelper.startPage(pageNum, pageSize)` 即可实现分页。

## 🐛 常见问题

### 1. 数据库连接失败
- 检查 MySQL 服务是否启动
- 检查数据库连接配置（用户名、密码、端口）
- 确认数据库 `ems-db` 已创建

### 2. 端口被占用
- 修改 Tomcat 端口：编辑 `server.xml` 中的 `<Connector port="8080">`
- 或关闭占用 8080 端口的其他程序

### 3. Maven 依赖下载失败
- 检查网络连接
- 配置 Maven 镜像源（推荐使用阿里云镜像）

### 4. 页面显示异常
- 检查静态资源路径是否正确
- 确认 `web.xml` 中静态资源映射配置正确
- 清除浏览器缓存

### 5. 删除操作跳转页面
- 已修复：所有删除操作均使用 AJAX 方式，不会跳转页面
- 如果仍有问题，检查浏览器控制台错误信息

## 📄 数据库表结构

- `sys_user` - 用户信息表
- `emp` - 员工信息表
- `sys_dept` - 部门表
- `emp_post_level` - 岗位岗级表
- `emp_attendance_record` - 考勤记录表
- `emp_leave_record` - 请假记录表
- `emp_salary` - 薪资发放记录表
- `sys_dict` - 系统字典表

详细表结构请查看 `sql代码.sql` 文件。

## 🎨 界面特性

- **响应式设计**：支持不同屏幕尺寸
- **现代化UI**：使用 Bootstrap 组件，界面简洁美观
- **AJAX交互**：添加、删除操作使用模态框和AJAX，无需页面跳转
- **分页功能**：所有列表支持分页显示
- **搜索功能**：支持按条件搜索
- **权限控制**：基于角色的访问控制（RBAC）

## 📚 开发规范

- **包结构**：严格按照 MVC 分层架构
- **命名规范**：遵循 Java 驼峰命名规范
- **代码注释**：关键业务逻辑添加注释
- **异常处理**：统一使用 `RetJson` 返回结果

## 🔄 更新日志

### v1.0.0 (2025-03-05)
- ✅ 完成员工管理模块
- ✅ 完成部门、岗位、用户管理
- ✅ 完成考勤管理模块
- ✅ 完成请假审批模块
- ✅ 完成薪资管理模块
- ✅ 实现管理员和员工双角色系统
- ✅ 优化前端UI，使用模态框和AJAX交互
- ✅ 实现数据统计仪表盘

## 📞 联系方式

如有问题或建议，欢迎提交 Issue 或 Pull Request。

## 📄 许可证

本项目仅供学习交流使用。

---

**注意**：本项目为教学项目，生产环境使用请加强安全措施（如密码加密、SQL注入防护等）。
