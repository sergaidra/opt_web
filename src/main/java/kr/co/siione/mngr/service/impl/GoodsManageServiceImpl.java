package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.mngr.dao.FileManageDAO;
import kr.co.siione.mngr.dao.GoodsDAO;
import kr.co.siione.mngr.dao.GoodsKwrdDAO;
import kr.co.siione.mngr.dao.GoodsNmprDAO;
import kr.co.siione.mngr.dao.GoodsSchdulDAO;
import kr.co.siione.mngr.dao.GoodsTimeDAO;
import kr.co.siione.mngr.service.GoodsManageService;
import kr.co.siione.utl.UserJSONUtils;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("GoodsManageService")
public class GoodsManageServiceImpl implements GoodsManageService {

	private static final Logger LOG = LoggerFactory.getLogger(GoodsManageServiceImpl.class);

	@Resource(name = "GoodsDAO")
	private GoodsDAO goodsDAO;

	@Resource(name = "GoodsSchdulDAO")
	private GoodsSchdulDAO goodsSchdulDAO;

	@Resource(name = "GoodsTimeDAO")
	private GoodsTimeDAO goodsTimeDAO;

	@Resource(name = "GoodsNmprDAO")
	private GoodsNmprDAO goodsNmprDAO;

	@Resource(name = "GoodsKwrdDAO")
	private GoodsKwrdDAO goodsKwrdDAO;
	
	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;

	@Override
	public String insertGoodsForBass(Map<String, String> param) throws Exception {

		param.put("REGIST_PATH", "상품");
		String newFileCode = String.valueOf(fileManageDAO.insertFileManage(param));

		if(UserUtils.nvl(newFileCode).equals("")) {
			throw new Exception("상품 등록 중 오류 발생!");
		}

		param.put("FILE_CODE", newFileCode);
		String newGoodsCode = String.valueOf(goodsDAO.insertGoodsForBass(param));
		
		if(UserUtils.nvl(newGoodsCode).equals("")) {
			throw new Exception("상품 등록 중 오류 발생!!");
		}
		
		//키워드		
		String emptyText = "쉼표(,)로 구분하여 입력하세요";
		if(!StringUtils.trimToEmpty(param.get("KEYWORDS")).contains(emptyText)) {
			String[] arr = StringUtils.split(StringUtils.trimToEmpty(param.get("KEYWORDS")), ',');
			for(String str : arr) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("GOODS_CODE", newGoodsCode);
				map.put("KWRD", str);			
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				goodsKwrdDAO.insertGoodsKwrd(map);			
			}
		}

		// 특정인 상품
		Map<String, Object> mapUser = new HashMap<String, Object>();
		mapUser.put("GOODS_CODE", newGoodsCode);
		goodsDAO.deleteGoodsUser(mapUser);
		String[] arr = StringUtils.split(StringUtils.trimToEmpty(param.get("PARTICULAR_USERID")), ',');
		for(String str : arr) {
			if("".equals(str))
				continue;

			mapUser.put("USER_ID", str);
			goodsDAO.insertGoodsUser(mapUser);			
		}

		return newGoodsCode;
	}

	@Override
	public int updateGoodsForBass(Map<String, String> param) throws Exception {
		int iRe = goodsDAO.updateGoodsForBass(param);

		if(iRe == 0) {
			throw new Exception("기본정보 수정 중 오류 발생!");
		}
		
		//키워드
		goodsKwrdDAO.deleteGoodsKwrdInfos(param);
		
		String emptyText = "쉼표(,)로 구분하여 입력하세요";
		if(!StringUtils.trimToEmpty(param.get("KEYWORDS")).contains(emptyText)) {
			String[] arr = StringUtils.split(StringUtils.trimToEmpty(param.get("KEYWORDS")), ',');
			for(String str : arr) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("GOODS_CODE", param.get("GOODS_CODE"));
				map.put("KWRD", str);			
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				goodsKwrdDAO.insertGoodsKwrd(map);			
			}
		}

		// 특정인 상품
		Map<String, Object> mapUser = new HashMap<String, Object>();
		mapUser.put("GOODS_CODE", param.get("GOODS_CODE"));
		goodsDAO.deleteGoodsUser(mapUser);
		String[] arr = StringUtils.split(StringUtils.trimToEmpty(param.get("PARTICULAR_USERID")), ',');
		for(String str : arr) {
			if("".equals(str))
				continue;

			mapUser.put("USER_ID", str.trim());
			goodsDAO.insertGoodsUser(mapUser);			
		}

		return iRe;
	}

	@Override
	public int updateGoodsForGuidance(Map<String, String> param) throws Exception {
		int iRe = goodsDAO.updateGoodsForGuidance(param);

		if(iRe == 0) {
			throw new Exception("이용안내 수정 중 오류 발생!");
		}

		return iRe;
	}

	@Override
	public int updateGoodsForEtc(Map<String, String> param) throws Exception {
		int iRe = goodsDAO.updateGoodsForEtc(param);

		if(iRe == 0) {
			throw new Exception("기타정보 수정 중 오류 발생!");
		}

		return iRe;
	}

	@Override
	public int deleteGoods(Map<String, String> param) throws Exception {
		return goodsDAO.deleteGoods(param);
	}

	@Override
	public int deleteGoodsMulti(Map<String, Object> param) throws Exception {
		return goodsDAO.deleteGoodsMulti(param);
	}
	
	@Override
	public int recoverGoods(Map<String, String> param) throws Exception {
		return goodsDAO.recoverGoods(param);
	}	
	
	@Override
	public Map<String, Object> saveGoodsSchdul(Map<String, String> map) throws Exception {

		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();

		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("WRITNG_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));

				UserUtils.log("[saveGoodsSchdul]("+i+")", userJSONUtils.convertJson2Map(o));

				if (o.getString("CRUD").equals("C")) goodsSchdulDAO.insertGoodsSchdul(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) goodsSchdulDAO.updateGoodsSchdul(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) goodsSchdulDAO.deleteGoodsSchdul(userJSONUtils.convertJson2Map(o));
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

	@Override
	public Map<String, Object> saveGoodsTime(Map<String, String> map) throws Exception {

		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();

		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("WRITNG_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));

				UserUtils.log("[saveGoodsTime]("+i+")", userJSONUtils.convertJson2Map(o));

				if (o.getString("CRUD").equals("C")) goodsTimeDAO.insertGoodsTime(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) goodsTimeDAO.updateGoodsTime(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) goodsTimeDAO.deleteGoodsTime(userJSONUtils.convertJson2Map(o));
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

	@Override
	public Map<String, Object> saveGoodsNmpr(Map<String, String> map) throws Exception {

		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();

		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("WRITNG_ID", map.get("USER_ID"));
				o.put("UPDT_ID", map.get("USER_ID"));

				UserUtils.log("[saveGoodsNmpr]("+i+")", userJSONUtils.convertJson2Map(o));

				if (o.getString("CRUD").equals("C")) goodsNmprDAO.insertGoodsNmpr(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("U")) goodsNmprDAO.updateGoodsNmpr(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) goodsNmprDAO.deleteGoodsNmpr(userJSONUtils.convertJson2Map(o));
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

	@Override
	public Map<String, Object> saveGoodsFile(Map<String, String> map) throws Exception {

		Map<String,Object> result = new HashMap<String,Object>();
		UserJSONUtils userJSONUtils = new UserJSONUtils();

		try {
			JSONObject obj = userJSONUtils.convertMap2Json(map);

			JSONArray arr = obj.getJSONArray("data");

			for (int i = 0; i < arr.size(); i++) {
				JSONObject o = arr.getJSONObject(i);
				o.put("UPDT_ID", map.get("USER_ID"));

				UserUtils.log("[saveGoodsNmpr]("+i+")", userJSONUtils.convertJson2Map(o));

				if (o.getString("CRUD").equals("U")) fileManageDAO.updateFileDetail(userJSONUtils.convertJson2Map(o));
				if (o.getString("CRUD").equals("D")) fileManageDAO.deleteFileDetail(userJSONUtils.convertJson2Map(o));
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
	
	@Override
	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception {
		return goodsDAO.selectGoodsByPk(param);
	}

	@Override
	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception {
		return goodsDAO.selectGoodsList(param);
	}

	@Override
	public int selectGoodsListForSearchCount(Map<String, String> param) throws Exception {
		return goodsDAO.selectGoodsListForSearchCount(param);
	}
	
	@Override
	public List<Map<String, String>> selectGoodsListForSearch(Map<String, String> param) throws Exception {
		return goodsDAO.selectGoodsListForSearch(param);
	}

	@Override
	public List<Map<String, String>> selectGoodsSchdulList(Map<String, String> param) throws Exception {
		return goodsSchdulDAO.selectGoodsSchdulList(param);
	}

	@Override
	public List<Map<String, String>> selectGoodsTimeList(Map<String, String> param) throws Exception {
		return goodsTimeDAO.selectGoodsTimeList(param);
	}

	@Override
	public List<Map<String, String>> selectGoodsNmprList(Map<String, String> param) throws Exception {
		return goodsNmprDAO.selectGoodsNmprList(param);
	}

	@Override
	public void uploadGoodsFile(Map<String, String> param) throws Exception {

		int cnt = fileManageDAO.selectFileReprsntCnt(param);
		if(cnt == 0) param.put("REPRSNT_AT", "Y");

		Map<String, String> map = goodsDAO.selectGoodsByPk(param);
		if(map != null) {
			param.put("FILE_CODE", UserUtils.nvl(map.get("FILE_CODE")));
		} else {
			throw new Exception("파일 업로드 중 오류가 발생했습니다.");
		}

		fileManageDAO.insertFileDetail(param);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void uploadGoodsFileMulti(Map<String, Object> params) throws Exception {
		
		Map<String, String> param = (Map<String, String>)params.get("param");
		int cnt = fileManageDAO.selectFileReprsntCnt(param);

		Map<String, String> map = goodsDAO.selectGoodsByPk(param);
		
		String sFileCode = "";
		if(map != null) {
			sFileCode = UserUtils.nvl(map.get("FILE_CODE"));
		} else {
			throw new Exception("파일 업로드 중 오류가 발생했습니다.");
		}
		
		// 파일
		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");
		
		for(int i = 0 ; i < fileParamList.size() ; i++) {
			Map<String, String> fileParam = (Map<String, String>) fileParamList.get(i);

			/*if(i == 0 && cnt == 0) {
				fileParam.put("REPRSNT_AT", "Y");
				fileParam.put("FILE_SN", String.valueOf(i+1));
				fileParam.put("SORT_NO", String.valueOf(i+1));				
			} else if(cnt == 0) {
				fileParam.put("REPRSNT_AT", "N");
				fileParam.put("FILE_SN", String.valueOf(i+1));
				fileParam.put("SORT_NO", String.valueOf(i+1));				
			} else {
				fileParam.put("REPRSNT_AT", "N");
			}*/
			
			if(i == 0 && cnt == 0) {
				fileParam.put("REPRSNT_AT", "Y");
			} else {
				fileParam.put("REPRSNT_AT", "N");
			}			
			fileParam.put("FILE_CODE", sFileCode);
			
			fileManageDAO.insertFileDetail(fileParam);
		}
	}

	@Override
	public int startSellingGoods(Map<String, String> param) throws Exception {
		int iRe = goodsDAO.startSellingGoods(param);

		if(iRe == 0) {
			throw new Exception("상품 판매 시작 중 오류 발생!");
		}

		return iRe;
	}

	@Override
	public String copyGoods(Map<String, String> param) throws Exception {

		try {
			param.put("REGIST_PATH", "상품");
			String newFileCode = String.valueOf(fileManageDAO.insertFileManage(param));
			String newGoodsCode = goodsDAO.getNewGoodsCode(param);

			param.put("FILE_CODE", newFileCode);		
			param.put("NEW_GOODS_CODE", newGoodsCode);
			
			goodsDAO.copyGoods(param);
			goodsKwrdDAO.copyKwrd(param);
			goodsNmprDAO.copyNmpr(param);
			goodsSchdulDAO.copySchdul(param);
			goodsTimeDAO.copyTime(param);

			// 파일
			Map<String, String> mapFile = new HashMap<String, String>();
			mapFile.put("GOODS_CODE", param.get("GOODS_CODE"));
			List<Map<String, String>> lstFile = fileManageDAO.selectFileDetailList(mapFile);

			String dt = UserUtils.getDate("yyyyMMddHHmmss");
			for(int i = 0; i < lstFile.size(); i++) {
				String file_path = lstFile.get(i).get("FILE_PATH");
				String saveFileNm = dt + "_" + lstFile.get(i).get("FILE_NM");
				String savePath = file_path.substring(0, file_path.lastIndexOf(File.separator) + 1);
				String new_file_path = savePath + saveFileNm;

            	String thumbFile_Path = StringUtils.replace(file_path, "GOODS", "GOODS\\thumb");
            	String thumbNew_File_Path = StringUtils.replace(new_file_path, "GOODS", "GOODS\\thumb");
            	String thumb_file_path_NM = thumbFile_Path.substring(0, thumbFile_Path.lastIndexOf(".")) + "_resize" + thumbFile_Path.substring(thumbFile_Path.lastIndexOf("."));
            	String new_thumb_file_path = thumbNew_File_Path.substring(0, thumbNew_File_Path.lastIndexOf(".")) + "_resize" + thumbNew_File_Path.substring(thumbNew_File_Path.lastIndexOf("."));
				
				if(fileIsLive(file_path)) {
					fileCopy(file_path, new_file_path);
				}
				if(fileIsLive(thumb_file_path_NM)) {
					fileCopy(thumb_file_path_NM, new_thumb_file_path);
				}

				lstFile.get(i).put("NEW_FILE_CODE", newFileCode);
				lstFile.get(i).put("FILE_PATH", new_file_path);
				lstFile.get(i).put("WRITNG_ID", param.get("WRITNG_ID"));
				
				fileManageDAO.copyFileDetail(lstFile.get(i));
			}

			return newGoodsCode;
		} catch(Exception ex) {
			ex.printStackTrace();
			throw new Exception("상품 등록 중 오류 발생!!");
		}
	}
	
	//파일을 복사하는 메소드
	public void fileCopy(String inFileName, String outFileName) {
		try {
			FileInputStream fis = new FileInputStream(inFileName);
			FileOutputStream fos = new FileOutputStream(outFileName);
	   
			int data = 0;
			while((data=fis.read())!=-1) {
				fos.write(data);
			}
			fis.close();
			fos.close();
		} catch (IOException e) {
			//TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	
	
	//파일을 존재여부를 확인하는 메소드
	public Boolean fileIsLive(String isLivefile) {
		File f1 = new File(isLivefile);
	  
		if(f1.exists())
		{
			return true;
		} else {
			return false;
		}
	}
}
