package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsHitDAO")
public class GoodsHitDAO extends EgovComAbstractDAO {

	public Object insertGoodsHit(Map<String, String> map) throws Exception {
		return insert("GoodsHitDAO.insertGoodsHit", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsHitList(Map<String, String> param) throws Exception {
		return list("GoodsHitDAO.selectGoodsHitList", param);
	}
	
	public int selectGoodsHitListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("GoodsHitDAO.selectGoodsHitListCount", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsHitStatsDay(Map<String, String> param) throws Exception {
		return list("GoodsHitDAO.selectGoodsHitStatsDay", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsHitStatsMonth(Map<String, String> param) throws Exception {
		return list("GoodsHitDAO.selectGoodsHitStatsMonth", param);
	}
		
}
