package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("PurchsDAO")
public class PurchsDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPurchsList(Map<String, String> param) throws Exception {
		return list("PurchsDAO.selectPurchsList", param);
	}
	
	public int selectPurchsListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("PurchsDAO.selectPurchsListCount", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPurchsGoodsList(Map<String, String> param) throws Exception {
		return list("PurchsDAO.selectPurchsGoodsList", param);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectPurchsListForSchdul(Map<String, String> param) throws Exception {
		return list("PurchsDAO.selectPurchsListForSchdul", param);
	}
	
	public int selectPurchsListForSchdulCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("PurchsDAO.selectPurchsListForSchdulCount", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectPayList(Map<String, String> param) throws Exception {
		return list("PurchsDAO.selectPayList", param);
	}	
}
