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
import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.gnrl.cmmn.service.impl.CommonDAO;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("BbsService")
public class BbsServiceImpl implements BbsService {

	@Resource(name = "bbsDAO")
	private BbsDAO bbsDAO;
	
	@Resource
	private CommonService commonService;
	
    public void insertBbs(HashMap map) throws Exception {
    	bbsDAO.insertBbs(map);
    	
    	if(!"A".equals(map.get("category"))) {
    		if("".equals(map.get("parent_bbs_sn"))) {
    	    	System.out.println("==> 문의메일 발송");
    	    	List<HashMap> lstManager = commonService.getManagerUser(map);
    	    	for(int i = 0;i < lstManager.size(); i++)
    	    		commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("contents"))), String.valueOf(lstManager.get(i).get("EMAIL")));
    	    	
        		commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("contents"))), "onepasstour@gmail.com"); 
        		//commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("contents"))), "leeyikw@gmail.com");
    		} else {
    	    	HashMap map2 = new HashMap();
    	    	map2.put("bbs_sn", String.valueOf(map.get("parent_bbs_sn")));	
    	    	HashMap bbs =  bbsDAO.viewBbs(map2);

    	    	System.out.println("==> 답변메일 발송");
    	    	commonService.mailReply(String.valueOf(bbs.get("CONTENTS_VIEW")), UserUtils.convertHtml2Text(String.valueOf(map.get("contents"))), String.valueOf(bbs.get("EMAIL")));
    		}
    	}
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
    
}
