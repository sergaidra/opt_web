package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface StplatManageService {

	public int updateStplat(Map<String, String> param) throws Exception;

	public Map<String, String> selectStplatByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectStplatList(Map<String, String> param) throws Exception;

}
