package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface GoodsInitService {
	
	public List<Map<String, String>> selectDtaInitList(Map<String, String> param) throws Exception;
	
	public int initGoodsDta(Map<String, String> param) throws Exception;
}
