# Migration Roadmap

## What is already migrated

- The project now boots with Spring Boot instead of relying on `web.xml`.
- Core configuration has moved to `application.yml`.
- MyBatis is kept with the existing mapper interfaces and XML files.
- Spring Security now protects the application using the existing session-based login state.
- CORS support is enabled so a future Vue frontend can call the backend directly.
- User password handling now supports gradual migration toward BCrypt.

## What still uses the legacy structure

- JSP pages are still present and continue to render the current admin and employee screens.
- Controllers still mix page rendering and AJAX endpoints.
- The current role model is still compatibility-based: `admin` is treated as the administrator account.
- Legacy XML files remain in the repository as reference, but the app no longer depends on them to start.

## Recommended next phase

1. Create a separate Vue frontend project such as `frontend-vue`.
2. Refactor page-oriented controllers into `/api/**` REST endpoints.
3. Replace the compatibility role logic with tables for users, roles, permissions, and departments.
4. Add attendance-rule, approval-workflow, and report-export modules.
5. Introduce device integration APIs for attendance machine callbacks, GPS check-in, and face-recognition providers.

## Suggested backend split for the attendance system

- `auth`: login, logout, current user, role permissions
- `employee`: employee profile, department, post, organization tree
- `attendance`: check-in, check-out, attendance records, abnormal attendance
- `rule`: attendance periods, overtime rules, leave types, holiday rules
- `approval`: leave, overtime, make-up punch, multi-level approval
- `report`: monthly, quarterly, yearly reports, Excel export, PDF export
- `system`: parameters, audit logs, backup, restore

## Local run command

```bash
mvn spring-boot:run
```

## Database configuration

The backend reads database settings from environment variables when available:

- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`

If no environment variables are provided, the application falls back to the original local MySQL defaults from the old project.
