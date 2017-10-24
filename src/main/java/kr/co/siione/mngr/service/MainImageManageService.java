package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface MainImageManageService {

	public List<Map<String, String>> selectMainImageList(Map<String, String> param) throws Exception;

	public void insertMainImage(Map<String, String> param) throws Exception;

	public void insertMainImageMulti(Map<String, Object> param) throws Exception;
	
	public Map<String, Object> saveMainImage(Map<String, String> param) throws Exception;
}

