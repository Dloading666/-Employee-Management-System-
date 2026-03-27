package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.LeaveRecord;
import edu.com.eams.domain.User;
import edu.com.eams.security.SessionUserSupport;
import edu.com.eams.service.LeaveRecordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/leaves")
public class LeaveApiController {

    private final LeaveRecordService leaveRecordService;

    public LeaveApiController(LeaveRecordService leaveRecordService) {
        this.leaveRecordService = leaveRecordService;
    }

    @GetMapping
    public RetJson<PageResult<LeaveRecord>> list(
            @RequestParam(value = "employeeName", required = false) String employeeName,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            HttpSession session) {
        User currentUser = SessionUserSupport.getCurrentUser(session);
        if (currentUser == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int start = (safePageNum - 1) * safePageSize;
        Long filterUserId = SessionUserSupport.isAdmin(session) ? null : currentUser.getId();
        List<LeaveRecord> records = leaveRecordService.getByCondition(employeeName, filterUserId, start, safePageSize);
        int total = leaveRecordService.countByCondition(employeeName, filterUserId);
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @PostMapping
    public RetJson<LeaveRecord> create(@RequestBody LeaveRecord leaveRecord, HttpSession session) {
        User currentUser = SessionUserSupport.getCurrentUser(session);
        if (currentUser == null) {
            return new RetJson<>(401, "Not logged in", null);
        }

        leaveRecord.setId(null);
        leaveRecord.setUserId(currentUser.getId());
        leaveRecord.setCreateTime(new Date());
        leaveRecord.setApproveUserId(null);
        leaveRecord.setApproveTime(null);
        leaveRecord.setApproveContent(null);
        leaveRecord.setRealEndTime(null);
        leaveRecord.setStatus(1);
        leaveRecordService.insert(leaveRecord);
        return RetJson.success(leaveRecord);
    }

    @PostMapping("/{id}/status")
    public RetJson<String> updateStatus(@PathVariable("id") Long id,
                                        @RequestBody StatusRequest request,
                                        HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }

        if (request == null || request.getStatus() == null) {
            return new RetJson<>(400, "Status is required", null);
        }

        User admin = SessionUserSupport.getCurrentUser(session);
        leaveRecordService.updateStatus(id, request.getStatus(), admin == null ? null : admin.getId(), new Date(), request.getRemark());
        return RetJson.success("Status updated");
    }

    @PostMapping("/batch-status")
    public RetJson<String> batchStatus(@RequestBody List<StatusItem> list, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }

        User admin = SessionUserSupport.getCurrentUser(session);
        Date now = new Date();
        int success = 0;
        if (list != null) {
            for (StatusItem item : list) {
                if (item == null || item.getId() == null || item.getStatus() == null) {
                    continue;
                }
                success += leaveRecordService.updateStatus(
                        item.getId(),
                        item.getStatus(),
                        admin == null ? null : admin.getId(),
                        now,
                        item.getRemark()
                );
            }
        }
        return RetJson.success("Updated " + success + " record(s)");
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id, HttpSession session) {
        if (!SessionUserSupport.isAdmin(session)) {
            return new RetJson<>(403, "Access denied", null);
        }
        leaveRecordService.delete(id);
        return RetJson.success("Deleted");
    }

    public static class StatusRequest {
        private Integer status;
        private String remark;

        public Integer getStatus() {
            return status;
        }

        public void setStatus(Integer status) {
            this.status = status;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }

    public static class StatusItem extends StatusRequest {
        private Long id;

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }
    }
}
