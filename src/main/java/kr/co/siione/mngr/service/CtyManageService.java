package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface CtyManageService {
	
	public void insertCty(Map<String, String> param) throws Exception;
	
	public int updateCty(Map<String, String> param) throws Exception;

	public int deleteCty(Map<String, String> param) throws Exception;

	public Map<String, Object> saveCtyInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectCtyByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectCtyList(Map<String, String> param) throws Exception;

}
