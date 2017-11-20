package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("UserDAO")
public class UserDAO extends EgovComAbstractDAO {
	
	public int updateUser(Map<String, String> map) throws Exception {
		return update("UserDAO.updateUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectUserList(Map<String, String> param) throws Exception {
		return list("UserDAO.selectUserList", param);
	}
	
	public int selectUserListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("UserDAO.selectUserListCount", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectUserLogList(Map<String, String> param) throws Exception {
		return list("UserDAO.selectUserLogList", param);
	}
	
	public int selectUserLogListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("UserDAO.selectUserLogListCount", param);
	}
}
