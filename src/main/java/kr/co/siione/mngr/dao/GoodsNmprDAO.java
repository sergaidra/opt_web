package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsNmprDAO")
public class GoodsNmprDAO extends EgovComAbstractDAO {
	
	public Object insertGoodsNmpr(Map<String, String> map) throws Exception {
		return insert("GoodsNmprDAO.insertGoodsNmpr", map);
	}

	public int updateGoodsNmpr(Map<String, String> map) throws Exception {
		return update("GoodsNmprDAO.updateGoodsNmpr", map);
	}
	
	public int deleteGoodsNmpr(Map<String, String> map) throws Exception {
		return delete("GoodsNmprDAO.deleteGoodsNmpr", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsNmprByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsNmprDAO.selectGoodsNmprByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsNmprList(Map<String, String> param) throws Exception {
		return list("GoodsNmprDAO.selectGoodsNmprList", param);
	}
	
	public Object copyNmpr(Map<String, String> map) throws Exception {
		return insert("GoodsNmprDAO.copyNmpr", map);
	}	
	
}
