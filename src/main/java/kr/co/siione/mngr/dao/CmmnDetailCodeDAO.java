package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("CmmnDetailCodeDAO")
public class CmmnDetailCodeDAO extends EgovComAbstractDAO {
	
	public Object insertCmmnDetailCode(Map<String, String> map) throws Exception {
		return insert("CmmnDetailCodeDAO.insertCmmnDetailCode", map);
	}

	public int updateCmmnDetailCode(Map<String, String> map) throws Exception {
		return update("CmmnDetailCodeDAO.updateCmmnDetailCode", map);
	}
	
	public int deleteCmmnDetailCode(Map<String, String> map) throws Exception {
		return delete("CmmnDetailCodeDAO.deleteCmmnDetailCode", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectCmmnDetailCodeByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("CmmnDetailCodeDAO.selectCmmnDetailCodeByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectCmmnDetailCodeList(Map<String, String> param) throws Exception {
		return list("CmmnDetailCodeDAO.selectCmmnDetailCodeList", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectCmmnDetailCodeTree(Map<String, String> param) throws Exception {
		return list("CmmnDetailCodeDAO.selectCmmnDetailCodeTree", param);
	}	
}
