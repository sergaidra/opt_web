package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("ConectHistDAO")
public class ConectHistDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectConectHistList(Map<String, String> param) throws Exception {
		return list("ConectHistDAO.selectConectHistList", param);
	}
	
	public int selectConectHistListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("ConectHistDAO.selectConectHistListCount", param);
	}	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectConectHistStatsDay(Map<String, String> param) throws Exception {
		return list("ConectHistDAO.selectConectHistStatsDay", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectConectHistStatsMonth(Map<String, String> param) throws Exception {
		return list("ConectHistDAO.selectConectHistStatsMonth", param);
	}	
}
