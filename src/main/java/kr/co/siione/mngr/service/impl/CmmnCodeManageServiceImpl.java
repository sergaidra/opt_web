package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.CmmnCodeDAO;
import kr.co.siione.mngr.service.CmmnCodeManageService;
import kr.co.siione.utl.UserJSONUtils;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("CmmnCodeManageService")
public class CmmnCodeManageServiceImpl implements CmmnCodeManageService {

	private static final Logger LOG = LoggerFactory.getLogger(CmmnCodeManageServiceImpl.class);
	
	@Resource(name = "CmmnCodeDAO")
	private CmmnCodeDAO cmmnCodeDAO;
	
	@Override
	public void insertCmmnCode(Map<String, String> param) throws Exception {
		cmmnCodeDAO.insertCmmnCode(param);
	}

	@Override
	public int updateCmmnCode(Map<String, String> param) throws Exception {
		return cmmnCodeDAO.deleteCmmnCode(param);
	}
	
	@Override
	public int deleteCmmnCode(Map<String, String> param) throws Exception {
		return cmmnCodeDAO.deleteCmmnCode(param);
	}

	@Override
	public Map<String, Object> saveCmmnCodeInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				UserUtils.log("saveCmmnCode", userJSONUtils.convertJson2Map(o));
				
				if (o.getString("CRUD").equals("C")) cmmnCodeDAO.insertCmmnCode(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) cmmnCodeDAO.updateCmmnCode(userJSONUtils.convertJson2Map(o));
				//if (o.getString("CRUD").equals("D")) cmmnCodeDAO.deleteCmmnCode(userJSONUtils.convertJson2Map(o));
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
	public Map<String, String> selectCmmnCodeByPk(Map<String, String> param) throws Exception {
		return cmmnCodeDAO.selectCmmnCodeByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectCmmnCodeList(Map<String, String> param) throws Exception {
		return cmmnCodeDAO.selectCmmnCodeList(param);
	}
	
	@Override
	public List<Map<String, String>> selectCmmnCodeTree(Map<String, String> param) throws Exception {
		return cmmnCodeDAO.selectCmmnCodeTree(param);
	}
}
