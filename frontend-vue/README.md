# frontend-vue

企业员工管理系统的 Vue 3 前端。

## 当前状态

以下页面已经全部迁移为原生 Vue 页面：

- 登录
- 首页统计
- 部门管理
- 岗位管理
- 员工管理
- 用户管理
- 考勤管理
- 请假申请
- 请假记录
- 请假审批
- 薪资管理
- 我的薪资
- 个人信息

旧 JSP 页面已经从主项目中移除，前端现在只通过 REST API 与后端通信。

## 本地开发

先启动后端：

```bash
cd ..
mvn spring-boot:run
```

再启动前端：

```bash
npm install
npm run dev
```

访问：

```text
http://localhost:5173/signin
```

## 构建

```bash
npm run build
```

## 说明

- 开发环境通过 [vite.config.js](/D:/javaWeb/demo/ssm_xml/frontend-vue/vite.config.js) 代理后端接口
- 当前统一走 `/api/**`
- 登录态基于后端 Session，前端请求默认携带 Cookie
