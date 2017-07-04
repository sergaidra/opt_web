package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsClDAO")
public class GoodsClDAO extends EgovComAbstractDAO {
	
	public Object insertGoodsCl(Map<String, String> map) throws Exception {
		return insert("GoodsClDAO.insertGoodsCl", map);
	}

	public int updateGoodsCl(Map<String, String> map) throws Exception {
		return update("GoodsClDAO.updateGoodsCl", map);
	}
	
	public int deleteGoodsCl(Map<String, String> map) throws Exception {
		return delete("GoodsClDAO.deleteGoodsCl", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsClByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsClDAO.selectGoodsClByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsClList(Map<String, String> param) throws Exception {
		return list("GoodsClDAO.selectGoodsClList", param);
	}
}
