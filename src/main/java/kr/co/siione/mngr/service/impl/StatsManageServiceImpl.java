package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.ConectHistDAO;
import kr.co.siione.mngr.service.StatsManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("StatsManageService")
public class StatsManageServiceImpl implements StatsManageService {

	private static final Logger LOG = LoggerFactory.getLogger(StatsManageServiceImpl.class);
	
	@Resource(name = "ConectHistDAO")
	private ConectHistDAO conectHistDAO;

	@Override
	public List<Map<String, String>> selectConectHistList(Map<String, String> param) throws Exception {
		return conectHistDAO.selectConectHistList(param);
	}
	
	public int selectConectHistListCount(Map<String, String> param) throws Exception {
		return conectHistDAO.selectConectHistListCount(param);
	}
	
	@Override
	public List<Map<String, String>> selectConectHistStatsDay(Map<String, String> param) throws Exception {
		return conectHistDAO.selectConectHistStatsDay(param);
	}
	
	@Override
	public List<Map<String, String>> selectConectHistStatsMonth(Map<String, String> param) throws Exception {
		return conectHistDAO.selectConectHistStatsMonth(param);
	}
}
