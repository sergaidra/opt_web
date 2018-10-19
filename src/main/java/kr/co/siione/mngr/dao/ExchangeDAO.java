package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("ExchangeDAO")
public class ExchangeDAO extends EgovComAbstractDAO {
	
	public Object insertExchange(Map<String, String> map) throws Exception {
		return insert("ExchangeDAO.insertExchange", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectExchangeList(Map<String, String> param) throws Exception {
		return list("ExchangeDAO.selectExchangeList", param);
	}
	
	public int selectExchangeListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("ExchangeDAO.selectExchangeListCount", param);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectExchangeHistoryList(Map<String, String> param) throws Exception {
		return list("ExchangeDAO.selectExchangeHistoryList", param);
	}
	
	public int selectExchangeHistoryListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("ExchangeDAO.selectExchangeHistoryListCount", param);
	}

}
