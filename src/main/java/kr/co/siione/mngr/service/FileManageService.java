package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface FileManageService {
	
	public List<Map<String, String>> selectFileDetailList(Map<String, String> param) throws Exception;

}
