package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("PurchsPointDAO")
public class PurchsPointDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPurchsPointList(Map<String, String> param) throws Exception {
		return list("PurchsPointDAO.selectPurchsPointList", param);
	}
	
	public int selectPurchsPointListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("PurchsPointDAO.selectPurchsPointListCount", param);
	}	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectUserPointList(Map<String, String> param) throws Exception {
		return list("PurchsPointDAO.selectUserPointList", param);
	}
	
	public int selectUserPointListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("PurchsPointDAO.selectUserPointListCount", param);
	}	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectUserPointSum(Map<String, String> param) throws Exception {
		return (Map<String, Object>)selectByPk("PurchsPointDAO.selectUserPointSum", param);
	}	
}
