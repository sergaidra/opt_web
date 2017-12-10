package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.FaqService;
import kr.co.siione.gnrl.cs.service.LiveViewService;

@Service("FaqService")
public class FaqServiceImpl implements FaqService {

	@Resource(name = "faqDAO")
	private FaqDAO faqDAO;

	public void insertBbs(HashMap map) throws Exception {
		faqDAO.insertBbs(map);
	}
	
	public void deleteBbs(HashMap map) throws Exception {
		faqDAO.deleteBbs(map);
	}
	
	public void updateBbs(HashMap map) throws Exception {
		faqDAO.updateBbs(map);
	}
	
	public HashMap viewBbs(HashMap map) throws Exception {
		return faqDAO.viewBbs(map);
	}
	
	public List<HashMap> selectBbsList(HashMap map) throws Exception {
		return faqDAO.selectBbsList(map);
	}
}
