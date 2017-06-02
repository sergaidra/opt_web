package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.service.TourCmpnyManageService;

import org.springframework.stereotype.Service;

@Service("TourCmpnyManageService")
public class TourCmpnyManageServiceImpl implements TourCmpnyManageService {

	@Resource(name = "TourCmpnyDAO")
	private TourCmpnyDAO tourCmpnyDAO;

	@Override
	public Map<String, Object> insertTourCmpny(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<String, Object> updateTourCmpny(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<String, Object> deleteTourCmpny(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Map<String, String>> selectTourCmpnyList(Map<String, String> param) throws Exception {
		return tourCmpnyDAO.selectTourCmpnyList(param);
	}

}
