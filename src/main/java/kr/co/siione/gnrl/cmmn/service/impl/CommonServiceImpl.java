package kr.co.siione.gnrl.cmmn.service.impl;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.RequestContextUtils;

import kr.co.siione.gnrl.cmmn.service.CommonService;

@Service("CommonService")
public class CommonServiceImpl implements CommonService {
	
	@Autowired
	private MessageSource messageSource;

	public String getMessage(String msg, HttpServletRequest request) {		
		return messageSource.getMessage(msg, null, RequestContextUtils.getLocale(request));
	}
}
