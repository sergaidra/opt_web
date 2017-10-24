package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.MainImageDAO;
import kr.co.siione.mngr.service.MainImageManageService;
import kr.co.siione.utl.UserJSONUtils;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("MainImageManageService")
public class MainImageManageServiceImpl implements MainImageManageService {

	private static final Logger LOG = LoggerFactory.getLogger(MainImageManageServiceImpl.class);
	
	@Resource(name = "MainImageDAO")
	private MainImageDAO mainImageDAO;
	
	@Override
	public List<Map<String, String>> selectMainImageList(Map<String, String> param) throws Exception {
		return mainImageDAO.selectMainImageList(param);
	}
	
	@Override
	public void insertMainImage(Map<String, String> param) throws Exception {
		mainImageDAO.insertMainImage(param);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void insertMainImageMulti(Map<String, Object> params) throws Exception {
		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");
		
		for(Map<String, String> fileParam : fileParamList) {
			mainImageDAO.insertMainImage(fileParam);
		}
	}	
	
	@Override
	public Map<String, Object> saveMainImage(Map<String, String> map) throws Exception {

		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();

		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("UPDT_ID", map.get("USER_ID"));

				UserUtils.log("[saveMainImage]("+i+")", userJSONUtils.convertJson2Map(o));
				
				mainImageDAO.updateMainImage(userJSONUtils.convertJson2Map(o));

				//if (o.getString("CRUD").equals("C")) goodsNmprDAO.insertGoodsNmpr(userJSONUtils.convertJson2Map(o));
				//if (o.getString("CRUD").equals("U")) goodsNmprDAO.updateGoodsNmpr(userJSONUtils.convertJson2Map(o));
				//if (o.getString("CRUD").equals("D")) goodsNmprDAO.deleteGoodsNmpr(userJSONUtils.convertJson2Map(o));
			}

			result.put("success", true);
		} catch (SQLException se) {
			LOG.error(se.getMessage());
			result.put("success", false);
			result.put("error"  , String.valueOf(se.getErrorCode()));
			result.put("message", se.getLocalizedMessage());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}

		return result;
	}	
}
