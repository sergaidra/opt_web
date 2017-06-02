package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("TourClDAO")
public class TourClDAO extends EgovComAbstractDAO {
	
	public Object insertTourCl(Map<String, String> map) throws Exception {
		return insert("TourClDAO.insertTourCl", map);
	}

	public int updateTourCl(Map<String, String> map) throws Exception {
		return update("TourClDAO.updateTourCl", map);
	}
	
	public int deleteTourCl(Map<String, String> map) throws Exception {
		return delete("TourClDAO.deleteTourCl", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourCl(Map<String, String> param) throws Exception {
		return list("TourClDAO.selectTourCl", param);
	}
}
