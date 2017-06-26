package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsDAO")
public class GoodsDAO extends EgovComAbstractDAO {
	
	public Object insertGoods(Map<String, String> map) throws Exception {
		return insert("GoodsDAO.insertGoods", map);
	}

	public int updateGoods(Map<String, String> map) throws Exception {
		return update("GoodsDAO.updateGoods", map);
	}
	
	public int deleteGoods(Map<String, String> map) throws Exception {
		return delete("GoodsDAO.deleteGoods", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsDAO.selectGoodsByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception {
		return list("GoodsDAO.selectGoodsList", param);
	}
}
