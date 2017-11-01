package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.MenuDAO;
import kr.co.siione.mngr.service.MenuManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("MenuManageService")
public class MenuManageServiceImpl implements MenuManageService {

	private static final Logger LOG = LoggerFactory.getLogger(MenuManageServiceImpl.class);
	
	@Resource(name = "MenuDAO")
	private MenuDAO menuDAO;

	@Override
	public void insertMenu(Map<String, String> param) throws Exception {
		menuDAO.insertMenu(param);
	}

	@Override
	public int updateMenu(Map<String, String> param) throws Exception {
		return menuDAO.updateMenu(param);
	}

	@Override
	public Map<String, Object> saveMenuInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) menuDAO.insertMenu(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) menuDAO.updateMenu(userJSONUtils.convertJson2Map(o));
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
	public List<Map<String, Object>> selectMenuList(Map<String, String> param) throws Exception {
		return menuDAO.selectMenuList(param);
	}
	
	@Override
	public List<Map<String, Object>> selectUpperMenuTree(Map<String, String> param) throws Exception {
		return menuDAO.selectUpperMenuTree(param);
	}
	
	@Override
	public List<Map<String, Object>> selectMenuTree(Map<String, String> param) throws Exception {
		return menuDAO.selectMenuTree(param);
	}

}
