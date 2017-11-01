package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.CmmnDetailCodeDAO;
import kr.co.siione.mngr.service.CmmnDetailCodeManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("CmmnDetailCodeManageService")
public class CmmnDetailCodeManageServiceImpl implements CmmnDetailCodeManageService {

	private static final Logger LOG = LoggerFactory.getLogger(CmmnDetailCodeManageServiceImpl.class);
	
	@Resource(name = "CmmnDetailCodeDAO")
	private CmmnDetailCodeDAO cmmnDetailCodeDAO;
	
	@Override
	public void insertCmmnDetailCode(Map<String, String> param) throws Exception {
		cmmnDetailCodeDAO.insertCmmnDetailCode(param);
	}

	@Override
	public int updateCmmnDetailCode(Map<String, String> param) throws Exception {
		return cmmnDetailCodeDAO.deleteCmmnDetailCode(param);
	}
	
	@Override
	public int deleteCmmnDetailCode(Map<String, String> param) throws Exception {
		return cmmnDetailCodeDAO.deleteCmmnDetailCode(param);
	}

	@Override
	public Map<String, Object> saveCmmnDetailCodeInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("REGIST_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) cmmnDetailCodeDAO.insertCmmnDetailCode(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) cmmnDetailCodeDAO.updateCmmnDetailCode(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) cmmnDetailCodeDAO.deleteCmmnDetailCode(userJSONUtils.convertJson2Map(o));
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
	public Map<String, String> selectCmmnDetailCodeByPk(Map<String, String> param) throws Exception {
		return cmmnDetailCodeDAO.selectCmmnDetailCodeByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectCmmnDetailCodeList(Map<String, String> param) throws Exception {
		return cmmnDetailCodeDAO.selectCmmnDetailCodeList(param);
	}
	
	@Override
	public List<Map<String, String>> selectCmmnDetailCodeTree(Map<String, String> param) throws Exception {
		return cmmnDetailCodeDAO.selectCmmnDetailCodeTree(param);
	}	
}
