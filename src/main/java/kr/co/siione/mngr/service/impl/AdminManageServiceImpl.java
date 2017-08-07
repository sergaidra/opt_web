package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.AdminDAO;
import kr.co.siione.mngr.service.AdminManageService;

import org.springframework.stereotype.Service;

@Service("adminManageService")
public class AdminManageServiceImpl implements AdminManageService {

	@Resource(name = "AdminDAO")
	private AdminDAO adminDAO;

	
	@Override
	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception {
		return adminDAO.selectMenuTree(param);
	}


}
