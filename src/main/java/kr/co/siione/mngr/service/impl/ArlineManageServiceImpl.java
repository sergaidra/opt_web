package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.ArlineDAO;
import kr.co.siione.mngr.service.ArlineManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("ArlineManageService")
public class ArlineManageServiceImpl implements ArlineManageService {

	private static final Logger LOG = LoggerFactory.getLogger(ArlineManageServiceImpl.class);
	
	@Resource(name = "ArlineDAO")
	private ArlineDAO arlineDAO;
	
	@Override
	public void insertArline(Map<String, String> param) throws Exception {
		arlineDAO.insertArline(param);
	}

	@Override
	public int updateArline(Map<String, String> param) throws Exception {
		return arlineDAO.deleteArline(param);
	}
	
	@Override
	public int deleteArline(Map<String, String> param) throws Exception {
		return arlineDAO.deleteArline(param);
	}

	@Override
	public Map<String, Object> saveArlineInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("WRITNG_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) arlineDAO.insertArline(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) arlineDAO.updateArline(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) arlineDAO.deleteArline(userJSONUtils.convertJson2Map(o));
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
	public Map<String, String> selectArlineByPk(Map<String, String> param) throws Exception {
		return arlineDAO.selectArlineByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectArlineList(Map<String, String> param) throws Exception {
		return arlineDAO.selectArlineList(param);
	}
}
