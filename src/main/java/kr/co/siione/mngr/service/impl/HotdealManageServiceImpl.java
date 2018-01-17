package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.FileManageDAO;
import kr.co.siione.mngr.dao.HotdealDAO;
import kr.co.siione.mngr.service.HotdealManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("HotdealManageService")
public class HotdealManageServiceImpl implements HotdealManageService {

	private static final Logger LOG = LoggerFactory.getLogger(HotdealManageServiceImpl.class);
	
	@Resource(name = "HotdealDAO")
	private HotdealDAO hotdealDAO;
	
	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;
	
	@Override
	public void insertHotdeal(Map<String, Object> params) throws Exception {
		
		Map<String, String> param = (HashMap<String, String>)params.get("param");

		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");

		Map<String, String> paramL = (HashMap<String, String>)fileParamList.get(0); 
		Map<String, String> paramS = (HashMap<String, String>)fileParamList.get(1); 
		
		param.put("REGIST_PATH", "메인핫딜");
		String newFileCodeL = String.valueOf(fileManageDAO.insertFileManage(param));
		String newFileCodeS = String.valueOf(fileManageDAO.insertFileManage(param));
		
		param.put("FILE_CODE_L", newFileCodeL);
		param.put("FILE_CODE_S", newFileCodeS);
		paramL.put("FILE_CODE", newFileCodeL);
		paramS.put("FILE_CODE", newFileCodeS);
		
		fileManageDAO.insertFileDetail(paramL);
		fileManageDAO.insertFileDetail(paramS);
		hotdealDAO.insertHotdeal(param);
	}

	@Override
	public int updateHotdeal(Map<String, Object> params) throws Exception {
		
		Map<String, String> param = (HashMap<String, String>)params.get("param");
		
		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");
		
		for(Map<String, String> file : fileParamList) {
			fileManageDAO.deleteFileDetailInfos(file);
			fileManageDAO.insertFileDetail(file);
		}	
		
		return hotdealDAO.updateHotdeal(param);
	}
	
	@Override
	public int deleteHotdeal(Map<String, String> param) throws Exception {
		return hotdealDAO.deleteHotdeal(param);
	}
	
	@Override
	public Map<String, String> selectHotdealByPk(Map<String, String> param) throws Exception {
		return hotdealDAO.selectHotdealByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectHotdealList(Map<String, String> param) throws Exception {
		return hotdealDAO.selectHotdealList(param);
	}
}
