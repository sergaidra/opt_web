package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.ArprtDAO;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("ArprtManageService")
public class ArprtManageServiceImpl implements ArprtManageService {

	private static final Logger LOG = LoggerFactory.getLogger(ArprtManageServiceImpl.class);
	
	@Resource(name = "ArprtDAO")
	private ArprtDAO arprtDAO;
	
	@Override
	public void insertArprt(Map<String, String> param) throws Exception {
		arprtDAO.insertArprt(param);
	}

	@Override
	public int updateArprt(Map<String, String> param) throws Exception {
		return arprtDAO.deleteArprt(param);
	}
	
	@Override
	public int deleteArprt(Map<String, String> param) throws Exception {
		return arprtDAO.deleteArprt(param);
	}

	@Override
	public Map<String, Object> saveArprtInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) arprtDAO.insertArprt(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) arprtDAO.updateArprt(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) arprtDAO.deleteArprt(userJSONUtils.convertJson2Map(o));
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
	public Map<String, String> selectArprtByPk(Map<String, String> param) throws Exception {
		return arprtDAO.selectArprtByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectArprtList(Map<String, String> param) throws Exception {
		return arprtDAO.selectArprtList(param);
	}
}
