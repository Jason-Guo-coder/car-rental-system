package com.gjq.service;

import org.springframework.web.multipart.MultipartFile;

public interface IOssService {

    String upload(MultipartFile file);

    boolean delete(String url);

}
