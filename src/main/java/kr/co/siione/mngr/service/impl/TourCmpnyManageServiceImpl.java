package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.TourCmpnyDAO;
import kr.co.siione.mngr.service.TourCmpnyManageService;

import org.springframework.stereotype.Service;

@Service("TourCmpnyManageService")
public class TourCmpnyManageServiceImpl implements TourCmpnyManageService {

	@Resource(name = "TourCmpnyDAO")
	private TourCmpnyDAO tourCmpnyDAO;

	@Override
	public void insertTourCmpny(Map<String, String> param) throws Exception {
		tourCmpnyDAO.insertTourCmpny(param);
	}

	@Override
	public int updateTourCmpny(Map<String, String> param) throws Exception {
		return tourCmpnyDAO.updateTourCmpny(param);
	}

	@Override
	public int deleteTourCmpny(Map<String, String> param) throws Exception {
		return tourCmpnyDAO.deleteTourCmpny(param);
	}

	@Override
	public Map<String, String> selectTourCmpnyByPk(Map<String, String> param) throws Exception {
		return tourCmpnyDAO.selectTourCmpnyByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectTourCmpnyList(Map<String, String> param) throws Exception {
		return tourCmpnyDAO.selectTourCmpnyList(param);
	}

}
