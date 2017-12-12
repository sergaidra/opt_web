package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.QnaService;

@Service("QnaService")
public class QnaServiceImpl implements QnaService {

	@Resource(name = "qnaDAO")
	private QnaDAO qnaDAO;

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
	}
	
	public void updateOpinion(HashMap map) throws Exception {
		qnaDAO.updateOpinion(map);
	}
	
	public HashMap viewOpinion(HashMap map) throws Exception {
		return qnaDAO.viewOpinion(map);
	}
}
