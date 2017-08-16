package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("ArlineDAO")
public class ArlineDAO extends EgovComAbstractDAO {
	
	public Object insertArline(Map<String, String> map) throws Exception {
		return insert("ArlineDAO.insertArline", map);
	}

	public int updateArline(Map<String, String> map) throws Exception {
		return update("ArlineDAO.updateArline", map);
	}
	
	public int deleteArline(Map<String, String> map) throws Exception {
		return delete("ArlineDAO.deleteArline", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectArlineByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("ArlineDAO.selectArlineByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectArlineList(Map<String, String> param) throws Exception {
		return list("ArlineDAO.selectArlineList", param);
	}
}
