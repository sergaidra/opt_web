package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface GoodsManageService {
	
	public String insertGoodsForBass(Map<String, String> param) throws Exception;
	
	public int updateGoodsForBass(Map<String, String> param) throws Exception;

	public int updateGoodsForGuidance(Map<String, String> param) throws Exception;

	public int updateGoodsForEtc(Map<String, String> param) throws Exception;

	public int deleteGoods(Map<String, String> param) throws Exception;

	public int deleteGoodsMulti(Map<String, Object> param) throws Exception;
	
	public Map<String, Object> saveGoodsSchdul(Map<String, String> param) throws Exception;

	public Map<String, Object> saveGoodsTime(Map<String, String> param) throws Exception;
	
	public Map<String, Object> saveGoodsNmpr(Map<String, String> param) throws Exception;
	
	public Map<String, Object> saveGoodsFile(Map<String, String> param) throws Exception;

	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGoodsListForSearch(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGoodsSchdulList(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectGoodsTimeList(Map<String, String> param) throws Exception;
	
	public List<Map<String, String>> selectGoodsNmprList(Map<String, String> param) throws Exception;

	public void uploadGoodsFile(Map<String, String> param) throws Exception;
	
	public void uploadGoodsFileMulti(Map<String, Object> param) throws Exception;
}
