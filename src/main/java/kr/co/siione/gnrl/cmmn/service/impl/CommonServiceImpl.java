package kr.co.siione.gnrl.cmmn.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.RequestContextUtils;

import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("CommonService")
public class CommonServiceImpl implements CommonService {
	
	@Autowired
	private MessageSource messageSource;
	
	@Resource(name = "commonDAO")
	private CommonDAO commonDAO;

	@Resource
    private	MailManager mailManager;
	
	@Value("#{globals['server.ip']}")
	private String webserverip;
	@Value("#{globals['server.domain']}")
	private String webserverdomain;

	public String getMessage(String msg, HttpServletRequest request) {		
		return messageSource.getMessage(msg, null, RequestContextUtils.getLocale(request));
	}
	
	public List<HashMap> getManagerUser(HashMap map) throws Exception {
		return commonDAO.getManagerUser(map);
	}

	public void mailRequest(String request, String email) throws Exception {
    	if(!UserUtils.nvl(email).equals("")) {
    		String subject = "원패스투어에 질문이 등록되었습니다.";
    		String content = getHtml("mailRequest.htm");
    		
    		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
    		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
    		content = content.replaceAll("[$]\\{contents1\\}", request);
    			
    		Map<String, Object> attachMap = new HashMap<String, Object>();
    		attachMap.put("images", new ArrayList());    		
    		mailManager.sendMail(subject, content, email, attachMap);	
    	}
	}

	public void mailReply(String request, String answer, String email) throws Exception {
    	if(!UserUtils.nvl(email).equals("")) {
    		String subject = "원패스투어 문의하신 내용에 대한 답변을 드립니다.";
    		String content = getHtml("mailReply.htm");
    		
    		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
    		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
    		content = content.replaceAll("[$]\\{contents1\\}", request);
    		content = content.replaceAll("[$]\\{contents2\\}", answer);
    			
    		Map<String, Object> attachMap = new HashMap<String, Object>();
    		attachMap.put("images", new ArrayList());    		
    		mailManager.sendMail(subject, content, email, attachMap);	
    	}
	}
	
	private String getHtml(String filename) {
		StringBuilder builder = new StringBuilder();
		org.springframework.core.io.Resource resource = new ClassPathResource("html/" + filename); 
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(resource.getInputStream(), "UTF-8"));
			String line = null;
            while ((line = reader.readLine()) != null)
                builder.append(line);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return builder.toString();
	}	    

}
