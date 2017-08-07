package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface AdminManageService {

	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception;

}
