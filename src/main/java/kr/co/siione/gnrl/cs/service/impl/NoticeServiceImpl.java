package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.NoticeService;

@Service("NoticeService")
public class NoticeServiceImpl implements NoticeService {

	@Resource(name = "noticeDAO")
	private NoticeDAO noticeDAO;

	public void insertBbs(HashMap map) throws Exception {
		noticeDAO.insertBbs(map);
	}
	
	public void deleteBbs(HashMap map) throws Exception {
		noticeDAO.deleteBbs(map);
	}
	
	public void updateBbs(HashMap map) throws Exception {
		noticeDAO.updateBbs(map);
	}
	
	public HashMap viewBbs(HashMap map) throws Exception {
		return noticeDAO.viewBbs(map);
	}

	public List<HashMap> mainNoticelist(HashMap map) throws Exception {
		return noticeDAO.mainNoticelist(map);
	}

	public HashMap mainPopupNotice(HashMap map) throws Exception {
		return noticeDAO.mainPopupNotice(map);
	}

}
