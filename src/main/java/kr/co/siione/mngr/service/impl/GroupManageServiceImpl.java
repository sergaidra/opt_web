package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.GroupDAO;
import kr.co.siione.mngr.service.GroupManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("GroupManageService")
public class GroupManageServiceImpl implements GroupManageService {

	private static final Logger LOG = LoggerFactory.getLogger(GroupManageServiceImpl.class);
	
	@Resource(name = "GroupDAO")
	private GroupDAO groupDAO;
	
	@Override
	public void insertGroup(Map<String, String> param) throws Exception {
		groupDAO.insertGroup(param);
	}

	@Override
	public int updateGroup(Map<String, String> param) throws Exception {
		return groupDAO.deleteGroup(param);
	}
	
	@Override
	public int deleteGroup(Map<String, String> param) throws Exception {
		return groupDAO.deleteGroup(param);
	}

	@Override
	public Map<String, Object> saveGroupInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) groupDAO.insertGroup(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) groupDAO.updateGroup(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) groupDAO.deleteGroup(userJSONUtils.convertJson2Map(o));
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
	public Map<String, String> selectGroupByPk(Map<String, String> param) throws Exception {
		return groupDAO.selectGroupByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectGroupList(Map<String, String> param) throws Exception {
		return groupDAO.selectGroupList(param);
	}
}
