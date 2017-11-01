package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.AuthorMenuDAO;
import kr.co.siione.mngr.service.AuthorMenuManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("AuthorMenuManageService")
public class AuthorMenuManageServiceImpl implements AuthorMenuManageService {

	private static final Logger LOG = LoggerFactory.getLogger(AuthorMenuManageServiceImpl.class);
	
	@Resource(name = "AuthorMenuDAO")
	private AuthorMenuDAO authorMenuDAO;
	
	@Override
	public void insertAuthorMenu(Map<String, String> param) throws Exception {
		authorMenuDAO.insertAuthorMenu(param);
	}
	
	@Override
	public int deleteAuthorMenu(Map<String, String> param) throws Exception {
		return authorMenuDAO.deleteAuthorMenu(param);
	}

	@Override
	public Map<String, Object> saveAuthorMenuInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			JSONArray arr = obj.getJSONArray("data");
			authorMenuDAO.deleteAuthorMenu(userJSONUtils.convertJson2Map(obj));
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				authorMenuDAO.insertAuthorMenu(userJSONUtils.convertJson2Map(o));
			}			
			
			result.put("success", true);
		} catch (SQLException se) {
			LOG.error(se.getMessage());
			result.put("success", false);
			result.put("error"  , String.valueOf(se.getErrorCode()));
			result.put("message", se.getLocalizedMessage());
			throw new Exception(se.getLocalizedMessage());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
			throw new Exception(e.getLocalizedMessage());
		}
		
		return result;
	}
	
	@Override
	public Map<String, String> selectAuthorMenuByPk(Map<String, String> param) throws Exception {
		return authorMenuDAO.selectAuthorMenuByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectAuthorMenuList(Map<String, String> param) throws Exception {
		return authorMenuDAO.selectAuthorMenuList(param);
	}
	
	@Override
	public List<Map<String, String>> selectAuthorMenuTree(Map<String, String> param) throws Exception {
		return authorMenuDAO.selectAuthorMenuTree(param);
	}
	
	@Override
	public List<Map<String, String>> selectMainMenuTree(Map<String, String> param) throws Exception {
		return authorMenuDAO.selectMainMenuTree(param);
	}		
}
