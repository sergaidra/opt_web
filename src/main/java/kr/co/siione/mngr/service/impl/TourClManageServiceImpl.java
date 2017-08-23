package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.FileManageDAO;
import kr.co.siione.mngr.dao.TourClDAO;
import kr.co.siione.mngr.service.TourClManageService;
import kr.co.siione.utl.UserJSONUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("TourClManageService")
public class TourClManageServiceImpl implements TourClManageService {

	private static final Logger LOG = LoggerFactory.getLogger(TourClManageServiceImpl.class);
	
	@Resource(name = "TourClDAO")
	private TourClDAO tourClDAO;

	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;
	
	@Override
	public void insertTourCl(Map<String, String> param) throws Exception {
		Object fileCode = fileManageDAO.insertFileManage(param);
		param.put("FILE_CODE", String.valueOf(fileCode));
		fileManageDAO.insertFileDetail(param);
		tourClDAO.insertTourCl(param);
	}

	@Override
	public int updateTourCl(Map<String, String> param) throws Exception {
		int cnt = tourClDAO.updateTourCl(param);
		
		if(cnt == 1) {
			// 파일삭제
			List<Map<String, String>> files = fileManageDAO.selectFileDetailList(param);
			
			for(Map<String, String> fileInfo : files) {
				File file = new File(fileInfo.get("FILE_PATH").toString());
				file.delete();
			}
			
			if(fileManageDAO.deleteFileDetailInfos(param) > 0) {
				fileManageDAO.insertFileDetail(param);
			} else {
				throw new Exception("파일 삭제 중 오류 발생");
			}
		} else {
			throw new Exception("여행분류 수정 중 오류 발생");
		}
		
		return cnt;
	}
	
	@Override
	public int deleteTourCl(Map<String, String> param) throws Exception {
		return tourClDAO.deleteTourCl(param);
	}

	@Override
	public Map<String, Object> saveTourClInfo(Map<String, String> map) throws Exception {
		
		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();
		
		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);
			
			JSONArray arr = obj.getJSONArray("data");
			
			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("WRITNG_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));
				
				if (o.getString("CRUD").equals("C")) tourClDAO.insertTourCl(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) tourClDAO.updateTourCl(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) tourClDAO.deleteTourCl(userJSONUtils.convertJson2Map(o));
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
	public int uploadTourClFile(Map<String, String> param) throws Exception {

		int iRe = 0;
		int cnt = tourClDAO.selectTourClFileCnt(param);
		
		if(cnt == 0) {
			// insert tb_file_manage			
			Object fileCode = fileManageDAO.insertFileManage(param);
			param.put("FILE_CODE", String.valueOf(fileCode));
						
			// insert tb_file_detail
			fileManageDAO.insertFileDetail(param);
			
			// update tb_tour_cl
			iRe = tourClDAO.updateTourCl(param);
			
		} else {
			// update tb_file_detail
			
			// 파일삭제
			List<Map<String, String>> files = fileManageDAO.selectFileDetailList(param);
			
			for(Map<String, String> fileInfo : files) {
				File file = new File(fileInfo.get("FILE_PATH").toString());
				boolean bRe = file.delete();
				LOG.debug("[uploadTourClFile]bRe:"+bRe);
			}
			
			//iRe = fileManageDAO.updateFileDetail(param);
			if(fileManageDAO.deleteFileDetailInfos(param) > 0) {
				fileManageDAO.insertFileDetail(param);
				iRe = 1;
			}			
		}
		LOG.debug("[uploadTourClFile]iRe:"+iRe);	
		return iRe;
	}
	
	@Override
	public Map<String, String> selectTourClByPk(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectTourClList(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClList(param);
	}

	@Override
	public List<Map<String, String>> selectTourClUpperList(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClUpperList(param);
	}
	
	@Override
	public List<Map<String, String>> selectTourClTree(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClTree(param);
	}	
}
