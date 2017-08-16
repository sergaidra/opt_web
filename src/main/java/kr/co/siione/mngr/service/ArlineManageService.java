package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface ArlineManageService {
	
	public void insertArline(Map<String, String> param) throws Exception;
	
	public int updateArline(Map<String, String> param) throws Exception;

	public int deleteArline(Map<String, String> param) throws Exception;

	public Map<String, Object> saveArlineInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectArlineByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectArlineList(Map<String, String> param) throws Exception;

}
