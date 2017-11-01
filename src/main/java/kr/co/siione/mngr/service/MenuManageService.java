package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface MenuManageService {

	public void insertMenu(Map<String, String> param) throws Exception;
	
	public int updateMenu(Map<String, String> param) throws Exception;
	
	public Map<String, Object> saveMenuInfo(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectMenuList(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectUpperMenuTree(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception;

}
