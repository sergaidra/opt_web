package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.PurchsDAO;
import kr.co.siione.mngr.service.PurchsManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("PurchsManageService")
public class PurchsManageServiceImpl implements PurchsManageService {

	private static final Logger LOG = LoggerFactory.getLogger(PurchsManageServiceImpl.class);
	
	@Resource(name = "PurchsDAO")
	private PurchsDAO purchsDAO;

	public List<Map<String, Object>> selectPurchsList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsList(param);
	}
	
	public int selectPurchsListCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListCount(param);
	}
	
	public List<Map<String, Object>> selectPurchsGoodsList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsGoodsList(param);
	}
	
	public List<Map<String, String>> selectPurchsListForSchdul(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListForSchdul(param);
	}
	
	public int selectPurchsListForSchdulCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListForSchdulCount(param);
	}
	
	public List<Map<String, String>> selectPayList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPayList(param);
	}
	
	@Override
	public int refundPurchs(Map<String, String> param) throws Exception {
		int iRe = purchsDAO.refundPurchs(param);

		if(iRe == 0) {
			throw new Exception("환불처리 중 오류 발생!");
		}

		return iRe;
	}
	
	public List<Map<String, Object>> selectOrderWaitList(Map<String, String> param) throws Exception {
		return purchsDAO.selectOrderWaitList(param);
	}
	
	public int selectOrderWaitListCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectOrderWaitListCount(param);
	}
	
	public int updateReservationStatus(Map<String, String> map) throws Exception {
		return purchsDAO.updateReservationStatus(map);
	}
}
