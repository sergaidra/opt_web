package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsDAO")
public class GoodsDAO extends EgovComAbstractDAO {
	
	public Object insertGoods(Map<String, String> map) throws Exception {
		return insert("GoodsDAO.insertGoods", map);
	}
	
	public Object insertGoodsForBass(Map<String, String> map) throws Exception {
		return insert("GoodsDAO.insertGoodsForBass", map);
	}
	
	public int updateGoods(Map<String, String> map) throws Exception {
		return update("GoodsDAO.updateGoods", map);
	}
	
	public int updateGoodsForBass(Map<String, String> map) throws Exception {
		int iRe = update("GoodsDAO.updateGoodsForBass", map);
		iRe += update("GoodsDAO.updateGoodsEngForBass", map);
		return iRe;
	}
	
	public int updateGoodsForGuidance(Map<String, String> map) throws Exception {
		int iRe = update("GoodsDAO.updateGoodsForGuidance", map);
		iRe += update("GoodsDAO.updateGoodsEngForGuidance", map);
		return iRe;
	}	
	
	public int updateGoodsForEtc(Map<String, String> map) throws Exception {
		int iRe = update("GoodsDAO.updateGoodsForEtc", map);
		iRe += update("GoodsDAO.updateGoodsEngForEtc", map);
		return iRe;
	}	
	
	public int deleteGoods(Map<String, String> map) throws Exception {
		return delete("GoodsDAO.deleteGoods", map);
	}
	
	public int deleteGoodsMulti(Map<String, Object> map) throws Exception {
		return delete("GoodsDAO.deleteGoodsMulti", map);
	}
	
	public int startSellingGoods(Map<String, String> map) throws Exception {
		return update("GoodsDAO.startSellingGoods", map);
	}
	
	public int recoverGoods(Map<String, String> map) throws Exception {
		return delete("GoodsDAO.recoverGoods", map);
	}	

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsDAO.selectGoodsByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception {
		return list("GoodsDAO.selectGoodsList", param);
	}
	
	public int selectGoodsListForSearchCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("GoodsDAO.selectGoodsListForSearchCount", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsListForSearch(Map<String, String> param) throws Exception {
		return list("GoodsDAO.selectGoodsListForSearch", param);
	}
	
	public int deleteGoodsUser(Map<String, Object> map) throws Exception {
		return delete("GoodsDAO.deleteGoodsUser", map);
	}

	public int insertGoodsUser(Map<String, Object> map) throws Exception {
		return delete("GoodsDAO.insertGoodsUser", map);
	}

}
