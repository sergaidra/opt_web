package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface AuthorMenuManageService {
	
	public void insertAuthorMenu(Map<String, String> param) throws Exception;
	
	public int deleteAuthorMenu(Map<String, String> param) throws Exception;

	public Map<String, Object> saveAuthorMenuInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectAuthorMenuByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectAuthorMenuList(Map<String, String> param) throws Exception; 

	public List<Map<String, String>> selectAuthorMenuTree(Map<String, String> param) throws Exception; 
	
	public List<Map<String, String>> selectMainMenuTree(Map<String, String> param) throws Exception; 
}
