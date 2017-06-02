package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface TourCmpnyManageService {
	
	public Map<String, Object> insertTourCmpny(Map<String, String> param) throws Exception;
	
	public Map<String, Object> updateTourCmpny(Map<String, String> param) throws Exception;

	public Map<String, Object> deleteTourCmpny(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectTourCmpnyList(Map<String, String> param) throws Exception;

}
