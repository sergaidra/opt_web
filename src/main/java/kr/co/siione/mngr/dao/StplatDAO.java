package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("StplatDAO")
public class StplatDAO extends EgovComAbstractDAO {
	
	/*public Object insertStplat(Map<String, String> map) throws Exception {
		return insert("StplatDAO.insertStplat", map);
	}*/

	public int updateStplat(Map<String, String> map) throws Exception {
		insert("StplatDAO.insertStplatHist", map);
		return update("StplatDAO.updateStplat", map);
	}
	
	/*public int deleteStplat(Map<String, String> map) throws Exception {
		return delete("StplatDAO.deleteStplat", map);
	}*/

	@SuppressWarnings("unchecked")
	public Map<String, String> selectStplatByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("StplatDAO.selectStplatByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectStplatList(Map<String, String> param) throws Exception {
		return list("StplatDAO.selectStplatList", param);
	}
}
