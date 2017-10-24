package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface GroupManageService {
	
	public void insertGroup(Map<String, String> param) throws Exception;
	
	public int updateGroup(Map<String, String> param) throws Exception;

	public int deleteGroup(Map<String, String> param) throws Exception;

	public Map<String, Object> saveGroupInfo(Map<String, String> param) throws Exception;

	public Map<String, String> selectGroupByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGroupList(Map<String, String> param) throws Exception;

}
