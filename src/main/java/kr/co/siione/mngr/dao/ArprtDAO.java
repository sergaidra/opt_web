package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("ArprtDAO")
public class ArprtDAO extends EgovComAbstractDAO {
	
	public Object insertArprt(Map<String, String> map) throws Exception {
		return insert("ArprtDAO.insertArprt", map);
	}

	public int updateArprt(Map<String, String> map) throws Exception {
		return update("ArprtDAO.updateArprt", map);
	}
	
	public int deleteArprt(Map<String, String> map) throws Exception {
		return delete("ArprtDAO.deleteArprt", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectArprtByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("ArprtDAO.selectArprtByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectArprtList(Map<String, String> param) throws Exception {
		return list("ArprtDAO.selectArprtList", param);
	}
}
