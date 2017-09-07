package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("CtyDAO")
public class CtyDAO extends EgovComAbstractDAO {
	
	public Object insertCty(Map<String, String> map) throws Exception {
		return insert("CtyDAO.insertCty", map);
	}

	public int updateCty(Map<String, String> map) throws Exception {
		return update("CtyDAO.updateCty", map);
	}
	
	public int deleteCty(Map<String, String> map) throws Exception {
		return delete("CtyDAO.deleteCty", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectCtyByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("CtyDAO.selectCtyByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectCtyList(Map<String, String> param) throws Exception {
		return list("CtyDAO.selectCtyList", param);
	}
}
