package com.gjq.controller;

import com.gjq.service.IDashboardService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/rental/dashboard")
public class DashboardController {

    @Resource
    private IDashboardService dashboardService;

    @GetMapping("/overview")
    public Result overview(){
        return Result.success(dashboardService.overview());
    }
}
