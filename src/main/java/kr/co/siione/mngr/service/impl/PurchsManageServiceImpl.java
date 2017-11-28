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
	
}
