package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface PurchsManageService {
	
	public List<Map<String, Object>> selectPurchsList(Map<String, String> param) throws Exception;

	public int selectPurchsListCount(Map<String, String> param) throws Exception;
	
}
