package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface TourCmpnyManageService {
	
	public void insertTourCmpny(Map<String, String> param) throws Exception;
	
	public int updateTourCmpny(Map<String, String> param) throws Exception;

	public int deleteTourCmpny(Map<String, String> param) throws Exception;
	
	public Map<String, String> selectTourCmpnyByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectTourCmpnyList(Map<String, String> param) throws Exception;

}
