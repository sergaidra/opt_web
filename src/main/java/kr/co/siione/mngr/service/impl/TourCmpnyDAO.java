package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("TourCmpnyDAO")
public class TourCmpnyDAO extends EgovComAbstractDAO {
	
	public Object insertTourCmpny(Map<String, String> map) throws Exception {
		return insert("TourCmpnyDAO.insertTourCmpny", map);
	}

	public int updateTourCmpny(Map<String, String> map) throws Exception {
		return update("TourCmpnyDAO.updateTourCmpny", map);
	}
	
	public int deleteTourCmpny(Map<String, String> map) throws Exception {
		return delete("TourCmpnyDAO.deleteTourCmpny", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourCmpnyList(Map<String, String> param) throws Exception {
		return list("TourCmpnyDAO.selectTourCmpnyList", param);
	}
}
