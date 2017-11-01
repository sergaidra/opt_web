package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface CmmnCodeManageService {
	
	public void insertCmmnCode(Map<String, String> param) throws Exception;
	
	public int updateCmmnCode(Map<String, String> param) throws Exception;

	public int deleteCmmnCode(Map<String, String> param) throws Exception;

	public Map<String, Object> saveCmmnCodeInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectCmmnCodeByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectCmmnCodeList(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectCmmnCodeTree(Map<String, String> param) throws Exception;

}
