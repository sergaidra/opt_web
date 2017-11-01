package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("MenuDAO")
public class MenuDAO extends EgovComAbstractDAO {
	
	public Object insertMenu(Map<String, String> map) throws Exception {
		return insert("MenuDAO.insertMenu", map);
	}

	public int updateMenu(Map<String, String> map) throws Exception {
		return update("MenuDAO.updateMenu", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuList(Map<String, String> param) throws Exception {
		return list("MenuDAO.selectMenuList", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectUpperMenuTree(Map<String, String> param) throws Exception {
		return list("MenuDAO.selectUpperMenuTree", param);
	}

		@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception {
		return list("MenuDAO.selectMenuTree", param);
	}

}
