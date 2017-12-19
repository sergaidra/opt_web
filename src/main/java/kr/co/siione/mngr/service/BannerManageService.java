package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface BannerManageService {

	public List<Map<String, String>> selectBannerList(Map<String, String> param) throws Exception;

	public void insertBanner(Map<String, String> param) throws Exception;

	public void insertBannerMulti(Map<String, Object> param) throws Exception;
	
	public Map<String, Object> saveBanner(Map<String, String> param) throws Exception;
}

