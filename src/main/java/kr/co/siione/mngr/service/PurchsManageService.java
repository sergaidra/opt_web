package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface PurchsManageService {
	
	public List<Map<String, Object>> selectPurchsList(Map<String, String> param) throws Exception;

	public int selectPurchsListCount(Map<String, String> param) throws Exception;

	public List<Map<String, Object>> selectPurchsGoodsList(Map<String, String> param) throws Exception;
	
	public List<Map<String, String>> selectPurchsListForSchdul(Map<String, String> param) throws Exception;	
	
	public int selectPurchsListForSchdulCount(Map<String, String> param) throws Exception;
	
	public List<Map<String, String>> selectPayList(Map<String, String> param) throws Exception;
}
