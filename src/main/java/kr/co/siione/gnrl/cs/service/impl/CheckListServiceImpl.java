package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.CheckListService;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.ReviewService;
import kr.co.siione.gnrl.purchs.service.impl.PointDAO;

@Service("CheckListService")
public class CheckListServiceImpl implements CheckListService {

	@Resource(name = "checkListDAO")
	private CheckListDAO checkListDAO;

	public List<HashMap> getChecklist(HashMap map) throws Exception {
		return checkListDAO.getChecklist(map);
	}
	
	public void saveChecklist(HashMap map) throws Exception {
		checkListDAO.delChecklist(map);
		checkListDAO.insChecklist(map);
	}
}
