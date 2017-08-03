package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface FileManageService {
	
	public List<Map<String, String>> selectFileDetailList(Map<String, String> param) throws Exception;

	public Map<String, String> selectFileDetail(Map<String, String> param) throws Exception;

	public int deleteFileDetail(Map<String, String> param) throws Exception;
	
}
