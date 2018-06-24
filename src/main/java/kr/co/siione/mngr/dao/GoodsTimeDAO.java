package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GoodsTimeDAO")
public class GoodsTimeDAO extends EgovComAbstractDAO {
	
	public Object insertGoodsTime(Map<String, String> map) throws Exception {
		return insert("GoodsTimeDAO.insertGoodsTime", map);
	}

	public int updateGoodsTime(Map<String, String> map) throws Exception {
		return update("GoodsTimeDAO.updateGoodsTime", map);
	}
	
	public int deleteGoodsTime(Map<String, String> map) throws Exception {
		return delete("GoodsTimeDAO.deleteGoodsTime", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGoodsTimeByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GoodsTimeDAO.selectGoodsTimeByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGoodsTimeList(Map<String, String> param) throws Exception {
		return list("GoodsTimeDAO.selectGoodsTimeList", param);
	}
	
	public Object copyTime(Map<String, String> map) throws Exception {
		return insert("GoodsTimeDAO.copyTime", map);
	}	

}
