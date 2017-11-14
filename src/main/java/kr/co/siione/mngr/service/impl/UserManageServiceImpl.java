package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.UserDAO;
import kr.co.siione.mngr.service.UserManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("UserManageService")
public class UserManageServiceImpl implements UserManageService {

	private static final Logger LOG = LoggerFactory.getLogger(UserManageServiceImpl.class);
	
	@Resource(name = "UserDAO")
	private UserDAO userDAO;

	@Override
	public int updateUser(Map<String, String> param) throws Exception {
		return userDAO.updateUser(param);
	}

	@Override
	public List<Map<String, Object>> selectUserList(Map<String, String> param) throws Exception {
		return userDAO.selectUserList(param);
	}
	
	public int selectUserListCount(Map<String, String> param) throws Exception {
		return userDAO.selectUserListCount(param);
	}
	
	@Override
	public List<Map<String, Object>> selectUserLogList(Map<String, String> param) throws Exception {
		return userDAO.selectUserLogList(param);
	}
	
	public int selectUserLogListCount(Map<String, String> param) throws Exception {
		return userDAO.selectUserLogListCount(param);
	}
	
}
