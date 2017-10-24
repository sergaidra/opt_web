package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("GroupDAO")
public class GroupDAO extends EgovComAbstractDAO {
	
	public Object insertGroup(Map<String, String> map) throws Exception {
		return insert("GroupDAO.insertGroup", map);
	}

	public int updateGroup(Map<String, String> map) throws Exception {
		return update("GroupDAO.updateGroup", map);
	}
	
	public int deleteGroup(Map<String, String> map) throws Exception {
		return delete("GroupDAO.deleteGroup", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectGroupByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("GroupDAO.selectGroupByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectGroupList(Map<String, String> param) throws Exception {
		return list("GroupDAO.selectGroupList", param);
	}
}
