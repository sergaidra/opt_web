package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface StatsManageService {

	public List<Map<String, String>> selectConectHistList(Map<String, String> param) throws Exception;
	
	public int selectConectHistListCount(Map<String, String> param) throws Exception;
	
	public List<Map<String, String>> selectConectHistStatsDay(Map<String, String> param) throws Exception;

	public List<Map<String, String>> selectConectHistStatsMonth(Map<String, String> param) throws Exception;
	
}
