package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.siione.mngr.dao.StplatDAO;
import kr.co.siione.mngr.service.StplatManageService;

@Service("StplatManageService")
public class StplatManageServiceImpl implements StplatManageService {

	@Resource(name = "StplatDAO")
	private StplatDAO stplatDAO;
	
	@Override
	public int updateStplat(Map<String, String> param) throws Exception {
		return stplatDAO.updateStplat(param);
	}

	@Override
	public Map<String, String> selectStplatByPk(Map<String, String> param) throws Exception {
		return stplatDAO.selectStplatByPk(param);
	}

	@Override
	public List<Map<String, String>> selectStplatList(Map<String, String> param) throws Exception {
		return stplatDAO.selectStplatList(param);
	}

}
