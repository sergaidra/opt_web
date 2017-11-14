package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface UserManageService {

	public int updateUser(Map<String, String> param) throws Exception;
	
	public List<Map<String, Object>> selectUserList(Map<String, String> param) throws Exception;

	public int selectUserListCount(Map<String, String> param) throws Exception;
}
