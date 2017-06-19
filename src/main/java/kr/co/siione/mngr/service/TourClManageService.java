package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface TourClManageService {
	
	public void insertTourCl(Map<String, String> param) throws Exception;
	
	public int updateTourCl(Map<String, String> param) throws Exception;

	public int deleteTourCl(Map<String, String> param) throws Exception;
	
	public Map<String, String> selectTourClByPk(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectTourClList(Map<String, String> param) throws Exception;

}
