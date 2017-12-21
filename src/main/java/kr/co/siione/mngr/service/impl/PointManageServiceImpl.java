package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.PointDAO;
import kr.co.siione.mngr.dao.PurchsPointDAO;
import kr.co.siione.mngr.service.PointManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("PointManageService")
public class PointManageServiceImpl implements PointManageService {

	private static final Logger LOG = LoggerFactory.getLogger(PointManageServiceImpl.class);
	
	@Resource(name = "PointDAO")
	private PointDAO pointDAO;
	
	@Resource(name = "PurchsPointDAO")
	private PurchsPointDAO purchsPointDAO;

	public List<Map<String, Object>> selectPointList(Map<String, String> param) throws Exception {
		return pointDAO.selectPointList(param);
	}
	
	public int selectPointListCount(Map<String, String> param) throws Exception {
		return pointDAO.selectPointListCount(param);
	}
	
	public List<Map<String, Object>> selectPurchsPointList(Map<String, String> param) throws Exception {
		return purchsPointDAO.selectPurchsPointList(param);
	}
	
	public int selectPurchsPointListCount(Map<String, String> param) throws Exception {
		return purchsPointDAO.selectPurchsPointListCount(param);
	}

	public List<Map<String, Object>> selectUserPointList(Map<String, String> param) throws Exception {
		return purchsPointDAO.selectUserPointList(param);
	}
	
	public int selectUserPointListCount(Map<String, String> param) throws Exception {
		return purchsPointDAO.selectUserPointListCount(param);
	}
	
	public Map<String, Object> selectUserPointSum(Map<String, String> param) throws Exception {
		return purchsPointDAO.selectUserPointSum(param);
	}	
}
