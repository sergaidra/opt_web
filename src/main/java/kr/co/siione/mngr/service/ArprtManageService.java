package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface ArprtManageService {
	
	public void insertArprt(Map<String, String> param) throws Exception;
	
	public int updateArprt(Map<String, String> param) throws Exception;

	public int deleteArprt(Map<String, String> param) throws Exception;

	public Map<String, Object> saveArprtInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectArprtByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectArprtList(Map<String, String> param) throws Exception;

}
