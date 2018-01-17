package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface HotdealManageService {
	
	public void insertHotdeal(Map<String, Object> param) throws Exception;
	
	public int updateHotdeal(Map<String, Object> param) throws Exception;

	public int deleteHotdeal(Map<String, String> param) throws Exception;

	public Map<String, String> selectHotdealByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectHotdealList(Map<String, String> param) throws Exception;

}
