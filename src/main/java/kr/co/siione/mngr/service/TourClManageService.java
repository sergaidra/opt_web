package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface TourClManageService {
	
	public Map<String, Object> insertTourCl(Map<String, String> param) throws Exception;
	
	public Map<String, Object> updateTourCl(Map<String, String> param) throws Exception;

	public Map<String, Object> deleteTourCl(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectTourCl(Map<String, String> param) throws Exception;

}
