package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("HotdealDAO")
public class HotdealDAO extends EgovComAbstractDAO {
	
	public Object insertHotdeal(Map<String, String> map) throws Exception {
		return insert("HotdealDAO.insertHotdeal", map);
	}

	public int updateHotdeal(Map<String, String> map) throws Exception {
		return update("HotdealDAO.updateHotdeal", map);
	}
	
	public int deleteHotdeal(Map<String, String> map) throws Exception {
		return delete("HotdealDAO.deleteHotdeal", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectHotdealByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("HotdealDAO.selectHotdealByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectHotdealList(Map<String, String> param) throws Exception {
		return list("HotdealDAO.selectHotdealList", param);
	}
}
