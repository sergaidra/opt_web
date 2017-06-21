package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface MngrManageService {
	
	public void insertMngr(Map<String, String> param) throws Exception;
	
	public int updateMngr(Map<String, String> param) throws Exception;

	public int deleteMngr(Map<String, String> param) throws Exception;
	
	public int confrmMngr(Map<String, String> param) throws Exception;
	
	public Map<String, String> selectMngrByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectMngrList(Map<String, String> param) throws Exception;

}
