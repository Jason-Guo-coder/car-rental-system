package com.gjq.controller;

import com.gjq.service.IOssService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/rental/oss")
public class OssController {

    @Resource
    private IOssService ossService;

    @PostMapping("/upload")
    public Result upload(MultipartFile file) {
        return Result.success(ossService.upload(file));
    }
}
