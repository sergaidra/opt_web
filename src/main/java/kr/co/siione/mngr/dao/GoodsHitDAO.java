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

}
