package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("CmmnCodeDAO")
public class CmmnCodeDAO extends EgovComAbstractDAO {
	
	public Object insertCmmnCode(Map<String, String> map) throws Exception {
		return insert("CmmnCodeDAO.insertCmmnCode", map);
	}

	public int updateCmmnCode(Map<String, String> map) throws Exception {
		return update("CmmnCodeDAO.updateCmmnCode", map);
	}
	
	public int deleteCmmnCode(Map<String, String> map) throws Exception {
		return delete("CmmnCodeDAO.deleteCmmnCode", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectCmmnCodeByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("CmmnCodeDAO.selectCmmnCodeByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectCmmnCodeList(Map<String, String> param) throws Exception {
		return list("CmmnCodeDAO.selectCmmnCodeList", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectCmmnCodeTree(Map<String, String> param) throws Exception {
		return list("CmmnCodeDAO.selectCmmnCodeTree", param);
	}	
}
