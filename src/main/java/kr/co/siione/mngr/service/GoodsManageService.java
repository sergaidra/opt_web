package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface GoodsManageService {
	
	public void insertGoods(Map<String, String> param) throws Exception;
	
	public int updateGoods(Map<String, String> param) throws Exception;

	public int deleteGoods(Map<String, String> param) throws Exception;
	
	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception;

}
