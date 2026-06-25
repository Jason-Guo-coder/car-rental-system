package com.gjq.utils;

import com.gjq.service.IFinanceService;
import com.gjq.service.IMailService;
import com.gjq.vo.MailVO;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Component
public class SendMailUtils {

    @Resource
    private IFinanceService financeService;

    @Resource
    private IMailService mailService;

    @Value("${spring.mail.username}")
    private String from;

    @Scheduled(cron = "0 0 20 ? * *")//每晚八点发送邮件
    //@Scheduled(cron = "*/10 * * * * ?")
    public void sendMail() {
        StringBuffer sbf=new StringBuffer();
        sbf.append("今日收入：")
                .append("租金收入：")
                .append(financeService.sumRentPay().getCountRentActual())
                .append("，押金收入:")
                .append(financeService.sumDeposit());
        MailVO mailVo=new MailVO();
        mailVo.setFrom(from);
        mailVo.setTo("teacher_sivan@126.com");
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        mailVo.setSubject(date+"收入");
        mailVo.setContent(sbf.toString());
        mailService.sendMail(mailVo);
    }
}
