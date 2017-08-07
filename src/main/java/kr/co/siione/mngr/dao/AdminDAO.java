package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("AdminDAO")
public class AdminDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception {
		return list("AdminDAO.selectMenuTree", param);
	}

}
