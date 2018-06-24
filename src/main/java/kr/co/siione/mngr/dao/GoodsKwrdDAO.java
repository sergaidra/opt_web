package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsKwrdDAO")
public class GoodsKwrdDAO extends EgovComAbstractDAO {
	
	public Object insertGoodsKwrd(Map<String, String> map) throws Exception {
		return insert("GoodsKwrdDAO.insertGoodsKwrd", map);
	}

	public int updateGoodsKwrd(Map<String, String> map) throws Exception {
		return update("GoodsKwrdDAO.updateGoodsKwrd", map);
	}
	
	public int deleteGoodsKwrd(Map<String, String> map) throws Exception {
		return delete("GoodsKwrdDAO.deleteGoodsKwrd", map);
	}
	
	public int deleteGoodsKwrdInfos(Map<String, String> map) throws Exception {
		return delete("GoodsKwrdDAO.deleteGoodsKwrdInfos", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsKwrdByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsKwrdDAO.selectGoodsKwrdByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsKwrdList(Map<String, String> param) throws Exception {
		return list("GoodsKwrdDAO.selectGoodsKwrdList", param);
	}
	
	public Object copyKwrd(Map<String, String> map) throws Exception {
		return insert("GoodsKwrdDAO.copyKwrd", map);
	}	

}
