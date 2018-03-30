package kr.co.siione.gnrl.bbs.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("BbsService")
public class BbsServiceImpl implements BbsService {

	@Resource(name = "bbsDAO")
	private BbsDAO bbsDAO;
	
	@Resource
    private	MailManager mailManager;
	
	@Value("#{globals['server.ip']}")
	private String webserverip;
	@Value("#{globals['server.domain']}")
	private String webserverdomain;

    public void insertBbs(HashMap map) throws Exception {
    	bbsDAO.insertBbs(map);
    }
    
    public void deleteBbs(HashMap map) throws Exception {
    	bbsDAO.deleteBbs(map);
    }

    public void deleteAdminBbs(HashMap map) throws Exception {
    	bbsDAO.insertBbs(map);
    	bbsDAO.deleteAdminBbs(map);
    }

    public void updateBbs(HashMap map) throws Exception {
    	bbsDAO.updateBbs(map);
    }
    
    public void updateBbsViewCnt(HashMap map) throws Exception {
    	bbsDAO.updateBbsViewCnt(map);
    }

    public HashMap viewBbs(HashMap map)throws Exception {
    	return bbsDAO.viewBbs(map);
    } 
    
    public int selectBbsListCount(HashMap map) throws Exception {
    	return bbsDAO.selectBbsListCount(map);
    }

    public List<HashMap> selectBbsList(HashMap map) throws Exception {
    	return bbsDAO.selectBbsList(map);
    }

    public List<HashMap> selectChildBbsList(HashMap map) throws Exception {
    	return bbsDAO.selectChildBbsList(map);
    }
    
    public void insertComment(HashMap map) throws Exception {
    	bbsDAO.insertComment(map);
    }
    
    public void deleteComment(HashMap map) throws Exception {
    	bbsDAO.deleteComment(map);
    }

    public void updateComment(HashMap map) throws Exception {
    	bbsDAO.updateComment(map);
    }

    public List<HashMap> selectCommentList(HashMap map) throws Exception {
    	return bbsDAO.selectCommentList(map);
    }
    
    public boolean mailReply(HashMap map) throws Exception {
    	
    	boolean re = false;
    	
    	HashMap map2 = new HashMap();
    	map2.put("bbs_sn", String.valueOf(map.get("parent_bbs_sn")));	
    	HashMap bbs =  bbsDAO.viewBbs(map2);
    	
    	//System.out.println("bbs 원본글내용 : "+bbs);
    	
    	if(!UserUtils.nvl(bbs.get("EMAIL")).equals("")) {
    		String subject = "원패스투어 문의하신 내용에 대한 답변을 드립니다.";
    		String content = getHtml("mailReply.htm");
    		
    		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
    		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
    		content = content.replaceAll("[$]\\{contents1\\}", String.valueOf(bbs.get("CONTENTS_VIEW")));
    		content = content.replaceAll("[$]\\{contents2\\}", UserUtils.convertHtml2Text(String.valueOf(map.get("contents"))));
    			
    		Map<String, Object> attachMap = new HashMap<String, Object>();
    		attachMap.put("images", new ArrayList());    		
    		re = mailManager.sendMail(subject, content, String.valueOf(bbs.get("EMAIL")), attachMap);	
    	}
    	
    	return re;
    	
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
