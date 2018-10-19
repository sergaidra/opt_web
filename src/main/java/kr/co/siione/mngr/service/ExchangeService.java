package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface ExchangeService {
	
	public void insertExchange(Map<String, String> param) throws Exception;
	public List<Map<String, Object>> selectExchangeList(Map<String, String> param) throws Exception;	
	public int selectExchangeListCount(Map<String, String> param) throws Exception;
	public List<Map<String, Object>> selectExchangeHistoryList(Map<String, String> param) throws Exception;
	public int selectExchangeHistoryListCount(Map<String, String> param) throws Exception;
}
