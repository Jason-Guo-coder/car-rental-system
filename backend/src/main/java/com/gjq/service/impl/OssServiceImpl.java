package com.gjq.service.impl;

import cn.hutool.core.util.StrUtil;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.gjq.service.IOssService;
import com.gjq.utils.alioss.AliOSSProperties;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@Service
public class OssServiceImpl implements IOssService {

    @Resource
    private AliOSSProperties ossProperties;

    @Override
    public String upload(MultipartFile file) {
        // 上传文件的原始名
        String originalFilename = file.getOriginalFilename();
        // 生成新文件名，保留原始后缀，避免文件覆盖
        String fileName = UUID.randomUUID().toString()
                + originalFilename.substring(originalFilename.lastIndexOf("."));

        OSS ossClient = new OSSClientBuilder().build(
                ossProperties.getEndpoint(),
                ossProperties.getAccessKeyId(),
                ossProperties.getAccessKeySecret()
        );
        try {
            // 完成上传处理
            ossClient.putObject(ossProperties.getBucketName(), fileName, file.getInputStream());
            return "https://" + ossProperties.getBucketName() + "." + ossProperties.getEndpoint() + "/" + fileName;
        } catch (Exception e) {
            throw new RuntimeException("上传失败");
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }

    @Override
    public boolean delete(String url) {

        OSS ossClient = new OSSClientBuilder().build(
                ossProperties.getEndpoint(),
                ossProperties.getAccessKeyId(),
                ossProperties.getAccessKeySecret()
        );
        String host = "https://" + ossProperties.getBucketName() + "." + ossProperties.getEndpoint() + "/";
        // 去掉访问前缀，得到 OSS 上的对象名 xxx.png
        String objectName = StrUtil.removePrefix(url, host);
        try {
            ossClient.deleteObject(ossProperties.getBucketName(), objectName);
            return true;
        } catch (Exception e) {
            throw new RuntimeException("删除失败");
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }
    }
}
