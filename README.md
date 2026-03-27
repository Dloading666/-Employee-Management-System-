# 企业员工管理系统

当前项目已经完成到纯前后端分离形态：

- 后端：Spring Boot 3 + Spring Security + MyBatis + MySQL + Druid
- 前端：Vue 3 + Vite + Axios + Bootstrap + ECharts
- 架构：Vue 调用 Spring Boot REST API



## 功能模块

- 管理员端：首页统计、部门管理、岗位管理、员工管理、用户管理、考勤管理、薪资管理、请假审批
- 员工端：首页、个人信息、我的考勤、请假申请、请假记录、我的薪资

## 项目结构

```text
ssm_xml/
|-- src/main/java/edu/com/eams/
|   |-- config/
|   |-- controller/api/
|   |-- domain/
|   |-- mapper/
|   |-- security/
|   `-- service/
|-- src/main/resources/
|   |-- application.yml
|   |-- mapper/
|   `-- mybatis-config.xml
|-- frontend-vue/
|-- docs/
`-- pom.xml
```

## 环境要求

- JDK 17+
- Maven 3.9+
- Node.js 20+
- MySQL 8+

## 数据库准备

1. 创建数据库：

```sql
CREATE DATABASE `ems-db` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

2. 导入你本地使用的初始化 SQL。
3. 按需修改 [application.yml](/D:/javaWeb/demo/ssm_xml/src/main/resources/application.yml) 中的数据库连接配置。

## 启动方式

先启动后端：

```bash
mvn spring-boot:run
```

默认后端地址：

```text
http://localhost:8080
```

再启动前端：

```bash
cd frontend-vue
npm install
npm run dev
```

默认前端地址：

```text
http://localhost:5173/signin
```

前端开发环境通过 Vite 代理把 `/api/**` 转发到 Spring Boot。

## 默认账号

- 管理员：`admin / 123456`
- 普通员工：`lb / 123456`

如果你的本地数据库数据不同，请以 `sys_user` 表中的实际账号为准。

## 打包

后端打包：

```bash
mvn -DskipTests package
```

产物：

```text
target/attendance-management.war
```

前端打包：

```bash
cd frontend-vue
npm run build
```

产物：

```text
frontend-vue/dist
```

## 已完成的迁移

- Spring Boot 替代旧的 `web.xml` 和 XML 驱动启动方式
- Spring Security 接管登录态和权限控制
- Vue 前端覆盖管理员端和员工端主流程
- REST API 覆盖用户、岗位、员工、部门、考勤、请假、薪资、个人信息等核心模块
- 旧 JSP 页面与旧 MVC 页面控制器已完全移除

## 验证命令

```bash
mvn -DskipTests compile
mvn -DskipTests package
cd frontend-vue
npm run build
```

## 参考文档

- [migration-roadmap.md](/D:/javaWeb/demo/ssm_xml/docs/migration-roadmap.md)
- [frontend-vue/README.md](/D:/javaWeb/demo/ssm_xml/frontend-vue/README.md)
