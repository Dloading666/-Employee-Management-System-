package edu.cqie.eams.controller;
import edu.cqie.eams.domain.Attendance;
import edu.cqie.eams.service.AttendanceService;
import edu.cqie.eams.comm.RetJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.sql.Time;
import org.springframework.web.bind.WebDataBinder;
import java.beans.PropertyEditorSupport;
@Controller
@RequestMapping("/attendance")
public class AttendanceController {
    @Autowired
    private AttendanceService attendanceService;
    @GetMapping("/list")
    public String list(jakarta.servlet.http.HttpSession session, Model model) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Long currentUserId = ((edu.cqie.eams.domain.User)session.getAttribute("currentUser")).getId();
        Long filterUserId = isAdmin!=null && isAdmin ? null : currentUserId;
        System.out.println("[AttendanceController] user list request, isAdmin="+isAdmin+", filterUserId="+filterUserId);
        List<Attendance> records;
        if(filterUserId==null){
            records = attendanceService.getAll();
        }else{
            records = attendanceService.getByCondition(null, filterUserId,0, Integer.MAX_VALUE);
        }
        model.addAttribute("records", records);
        model.addAttribute("total", records.size());
        model.addAttribute("pageNum", 1);
        model.addAttribute("pageSize", records.size()==0?10:records.size());
        model.addAttribute("employeeName", null);
        return "attendanceList";
    }
    @GetMapping("/add")
    public String addForm() { return "attendanceAdd"; }
    @PostMapping("/add")
    public String add(Attendance attendance) {
        attendanceService.insert(attendance);
        return "redirect:/attendance/list";
    }
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("attendance", attendanceService.getById(id));
        return "attendanceEdit";
    }
    @PostMapping("/edit")
    public String edit(Attendance attendance) {
        attendanceService.update(attendance);
        return "redirect:/attendance/list";
    }
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long id) {
        attendanceService.delete(id);
        return "redirect:/attendance/list";
    }

    /**
     * AJAX 删除考勤记录
     */
    @PostMapping("/deleteJson/{id}")
    @ResponseBody
    public RetJson<String> deleteJson(@PathVariable("id") Long id) {
        try {
            attendanceService.delete(id);
            return RetJson.success("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            return RetJson.error("删除失败：" + e.getMessage());
        }
    }
    @GetMapping("/page")
    public String page(@RequestParam(value = "employeeName", required = false) String employeeName,
                       @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
                       @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
                       jakarta.servlet.http.HttpSession session,
                       Model model) {
        if (pageNum == null || pageNum < 1) pageNum = 1;
        if (pageSize == null || pageSize < 1) pageSize = 10;
        int start = (pageNum - 1) * pageSize;
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Long currentUserId = ((edu.cqie.eams.domain.User)session.getAttribute("currentUser")).getId();
        Long filterUserId = isAdmin!=null && isAdmin ? null : currentUserId;
        List<Attendance> records = attendanceService.getByCondition(employeeName, filterUserId, start, pageSize);
        int total = attendanceService.countByCondition(employeeName, filterUserId);
        model.addAttribute("records", records);
        model.addAttribute("total", total);
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("employeeName", employeeName);
        return "attendanceList";
    }
    @InitBinder
    public void initBinder(WebDataBinder binder){
        binder.registerCustomEditor(Time.class, new PropertyEditorSupport(){
            @Override
            public void setAsText(String text){
                if(text==null||text.isEmpty()){
                    setValue(null);
                }else{
                    // 若只有HH:mm，补秒
                    if(text.length()==5) text=text+":00";
                    setValue(Time.valueOf(text));
                }
            }
        });
    }
    @PostMapping("/check-in")
    @ResponseBody
    public edu.cqie.eams.comm.RetJson<String> checkIn(jakarta.servlet.http.HttpSession session) {
        edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
        if (user == null) return edu.cqie.eams.comm.RetJson.error("未登录");
        boolean ok = attendanceService.checkIn(user.getId(), user.getName());
        return ok ? edu.cqie.eams.comm.RetJson.success("签到成功") : edu.cqie.eams.comm.RetJson.error("您今天已签到过了");
    }
    @PostMapping("/check-out")
    @ResponseBody
    public edu.cqie.eams.comm.RetJson<String> checkOut(jakarta.servlet.http.HttpSession session) {
        edu.cqie.eams.domain.User user = (edu.cqie.eams.domain.User) session.getAttribute("currentUser");
        if (user == null) return edu.cqie.eams.comm.RetJson.error("未登录");
        boolean ok = attendanceService.checkOut(user.getId(), user.getName());
        return ok ? edu.cqie.eams.comm.RetJson.success("签退成功") : edu.cqie.eams.comm.RetJson.error("您今天已签退过了");
    }
} 