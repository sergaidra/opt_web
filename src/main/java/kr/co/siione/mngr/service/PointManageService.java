package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface PointManageService {
	
	public List<Map<String, Object>> selectPointList(Map<String, String> param) throws Exception;

	public int selectPointListCount(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectPurchsPointList(Map<String, String> param) throws Exception;

	public int selectPurchsPointListCount(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectUserPointList(Map<String, String> param) throws Exception;

	public int selectUserPointListCount(Map<String, String> param) throws Exception;

	public int selectUserPointSum(Map<String, String> param) throws Exception;
		
}
