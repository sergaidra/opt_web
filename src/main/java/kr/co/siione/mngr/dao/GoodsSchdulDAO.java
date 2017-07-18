package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsSchdulDAO")
public class GoodsSchdulDAO extends EgovComAbstractDAO {
	
	public Object insertGoodsSchdul(Map<String, String> map) throws Exception {
		return insert("GoodsSchdulDAO.insertGoodsSchdul", map);
	}

	public int updateGoodsSchdul(Map<String, String> map) throws Exception {
		return update("GoodsSchdulDAO.updateGoodsSchdul", map);
	}
	
	public int deleteGoodsSchdul(Map<String, String> map) throws Exception {
		return delete("GoodsSchdulDAO.deleteGoodsSchdul", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsSchdulByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsSchdulDAO.selectGoodsSchdulByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsSchdulList(Map<String, String> param) throws Exception {
		return list("GoodsSchdulDAO.selectGoodsSchdulList", param);
	}
}
