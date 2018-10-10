package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.QnaService;
import kr.co.siione.utl.UserUtils;

@Service("QnaService")
public class QnaServiceImpl implements QnaService {

	@Resource(name = "qnaDAO")
	private QnaDAO qnaDAO;

	@Resource
	private CommonService commonService;

	public int getOpinionListCount(HashMap map) throws Exception {
		return qnaDAO.getOpinionListCount(map);
	}
	
	public List<HashMap> getOpinionList(HashMap map) throws Exception {
		return qnaDAO.getOpinionList(map);
	}
	
	public List<HashMap> getOpinionAnswerList(HashMap map) throws Exception {
		return qnaDAO.getOpinionAnswerList(map);
	}
	
	public void insertOpinion(HashMap map) throws Exception {
		qnaDAO.insertOpinion(map);

		if("".equals(map.get("parent_opinion_sn"))) {
	    	System.out.println("==> 문의메일 발송");
	    	List<HashMap> lstManager = commonService.getManagerUser(map);
	    	for(int i = 0;i < lstManager.size(); i++)
	    		commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("opinion_cn"))), String.valueOf(lstManager.get(i).get("EMAIL")));
	    	
    		commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("opinion_cn"))), "onepasstour@gmail.com");
    		//commonService.mailRequest(UserUtils.convertHtml2Text(String.valueOf(map.get("opinion_cn"))), "leeyikw@gmail.com");
		} else {
	    	HashMap map2 = new HashMap();
	    	map2.put("opinion_sn", String.valueOf(map.get("parent_opinion_sn")));	
	    	HashMap opinion =  qnaDAO.viewOpinion(map2);

	    	System.out.println("==> 답변메일 발송");
	    	commonService.mailReply(String.valueOf(opinion.get("OPINION_CN")), UserUtils.convertHtml2Text(String.valueOf(map.get("opinion_cn"))), String.valueOf(opinion.get("EMAIL")));
		}
	}
	
	public void updateOpinion(HashMap map) throws Exception {
		qnaDAO.updateOpinion(map);
	}
	
	public HashMap viewOpinion(HashMap map) throws Exception {
		return qnaDAO.viewOpinion(map);
	}
	
	public void deleteOpinion(HashMap map) throws Exception {
		if("A".equals(map.get("delete_mode"))) {
			if("".equals(map.get("opinion_sn")))
				qnaDAO.insertOpinion(map);
	    	else
	    		qnaDAO.updateOpinion(map);
			
			map.put("delete_at", "A");
			map.put("opinion_sn", map.get("parent_opinion_sn"));
			qnaDAO.deleteOpinion(map);
		} else {
			map.put("delete_at", "Y");
			qnaDAO.deleteOpinion(map);
		}
	}
}
