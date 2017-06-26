package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("MngrDAO")
public class MngrDAO extends EgovComAbstractDAO {
	
	public Object insertMngr(Map<String, String> map) throws Exception {
		return insert("MngrDAO.insertMngr", map);
	}

	public int updateMngr(Map<String, String> map) throws Exception {
		return update("MngrDAO.updateMngr", map);
	}
	
	public int deleteMngr(Map<String, String> map) throws Exception {
		return delete("MngrDAO.deleteMngr", map);
	}

	public int confrmMngr(Map<String, String> map) throws Exception {
		return update("MngrDAO.confrmMngr", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, String> selectMngrByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("MngrDAO.selectMngrByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectMngrList(Map<String, String> param) throws Exception {
		return list("MngrDAO.selectMngrList", param);
	}
	
	@SuppressWarnings("deprecation")
	public String selectMngrIdForDup(Map<String, String> param) throws Exception {
		return (String)getSqlMapClient().queryForObject("MngrDAO.selectMngrIdForDup", param);
	}
}
