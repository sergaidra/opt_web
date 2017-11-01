package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface CmmnDetailCodeManageService {
	
	public void insertCmmnDetailCode(Map<String, String> param) throws Exception;
	
	public int updateCmmnDetailCode(Map<String, String> param) throws Exception;

	public int deleteCmmnDetailCode(Map<String, String> param) throws Exception;

	public Map<String, Object> saveCmmnDetailCodeInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectCmmnDetailCodeByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectCmmnDetailCodeList(Map<String, String> param) throws Exception;
	
	public List<Map<String, String>> selectCmmnDetailCodeTree(Map<String, String> param) throws Exception;

}
