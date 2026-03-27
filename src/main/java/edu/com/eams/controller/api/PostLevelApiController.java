package edu.com.eams.controller.api;

import edu.com.eams.comm.PageResult;
import edu.com.eams.comm.RetJson;
import edu.com.eams.domain.PostLevel;
import edu.com.eams.service.PostLevelService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/postlevels")
public class PostLevelApiController {

    private final PostLevelService postLevelService;

    public PostLevelApiController(PostLevelService postLevelService) {
        this.postLevelService = postLevelService;
    }

    @GetMapping
    public RetJson<PageResult<PostLevel>> list(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        int safePageNum = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int safePageSize = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int start = (safePageNum - 1) * safePageSize;
        List<PostLevel> records = postLevelService.getPostLevelsByCondition(name, start, safePageSize);
        int total = postLevelService.countPostLevelsByCondition(name);
        return RetJson.success(new PageResult<>(records, total, safePageNum, safePageSize));
    }

    @GetMapping("/{id}")
    public RetJson<PostLevel> detail(@PathVariable("id") Long id) {
        PostLevel postLevel = postLevelService.getPostLevelById(id);
        if (postLevel == null) {
            return new RetJson<>(404, "Post level not found", null);
        }
        return RetJson.success(postLevel);
    }

    @PostMapping
    public RetJson<PostLevel> create(@RequestBody PostLevel postLevel) {
        boolean success = postLevelService.addPostLevel(postLevel);
        if (!success) {
            return RetJson.error("Failed to create post level");
        }
        return RetJson.success(postLevel);
    }

    @PutMapping("/{id}")
    public RetJson<PostLevel> update(@PathVariable("id") Long id, @RequestBody PostLevel postLevel) {
        postLevel.setId(id);
        boolean success = postLevelService.updatePostLevel(postLevel);
        if (!success) {
            return RetJson.error("Failed to update post level");
        }
        return RetJson.success(postLevelService.getPostLevelById(id));
    }

    @DeleteMapping("/{id}")
    public RetJson<String> delete(@PathVariable("id") Long id) {
        boolean success = postLevelService.deletePostLevel(id);
        if (!success) {
            return RetJson.error("Failed to delete post level");
        }
        return RetJson.success("Deleted");
    }
}
