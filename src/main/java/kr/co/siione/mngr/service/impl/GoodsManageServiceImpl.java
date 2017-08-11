package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.FileManageDAO;
import kr.co.siione.mngr.dao.GoodsClDAO;
import kr.co.siione.mngr.dao.GoodsDAO;
import kr.co.siione.mngr.dao.GoodsNmprDAO;
import kr.co.siione.mngr.dao.GoodsSchdulDAO;
import kr.co.siione.mngr.dao.GoodsTimeDAO;
import kr.co.siione.mngr.service.GoodsManageService;
import kr.co.siione.utl.UserJSONUtils;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("GoodsManageService")
public class GoodsManageServiceImpl implements GoodsManageService {

	@Resource(name = "GoodsDAO")
	private GoodsDAO goodsDAO;

	@Resource(name = "GoodsClDAO")
	private GoodsClDAO goodsClDAO;

	@Resource(name = "GoodsSchdulDAO")
	private GoodsSchdulDAO goodsSchdulDAO;

	@Resource(name = "GoodsTimeDAO")
	private GoodsTimeDAO goodsTimeDAO;

	@Resource(name = "GoodsNmprDAO")
	private GoodsNmprDAO goodsNmprDAO;

	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;

	private static final Logger LOG = LoggerFactory.getLogger(GoodsManageServiceImpl.class);

	@Override
	public void insertGoods(Map<String, Object> params) throws Exception {

		// 파일
		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");
		int fileSn = 0;
		String newFileCode = "";
		for(Map<String, String> fileParam : fileParamList) {
			if(fileSn == 0) {
				newFileCode = String.valueOf(fileManageDAO.insertFileManage(fileParam));
			}
			fileParam.put("FILE_CODE", newFileCode);
			fileManageDAO.insertFileDetail(fileParam);
			fileSn++;
		}

		// 상품
		Map<String, String> goodsParam = (Map<String, String>)params.get("goodsParam");
		goodsParam.put("FILE_CODE", newFileCode);
		UserUtils.log("[addGoods][상품]", goodsParam);
		String newGoodsCode = String.valueOf(goodsDAO.insertGoods(goodsParam));

		if(UserUtils.nvl(newGoodsCode).equals("")) {
			throw new Exception("상품 등록 중 오류 발생!");
		}

		// 상품 분류
		List<Map<String, String>> clParamList = (List<Map<String, String>>)params.get("clParamList");
		for(Map<String, String> clParam : clParamList) {
			clParam.put("GOODS_CODE", newGoodsCode);
			goodsClDAO.insertGoodsCl(clParam);
		}

		// 상품 일정
		List<Map<String, String>> schdulParamList = (List<Map<String, String>>)params.get("schdulParamList");
		for(Map<String, String> schdulParam : schdulParamList) {
			schdulParam.put("GOODS_CODE", newGoodsCode);
			goodsSchdulDAO.insertGoodsSchdul(schdulParam);
		}

		// 상품 시간
		List<Map<String, String>> timeParamList = (List<Map<String, String>>)params.get("timeParamList");
		for(Map<String, String> timeParam : timeParamList) {
			timeParam.put("GOODS_CODE", newGoodsCode);
			goodsTimeDAO.insertGoodsTime(timeParam);
		}

		// 상품 인원
		List<Map<String, String>> nmprParamList = (List<Map<String, String>>)params.get("nmprParamList");
		for(Map<String, String> nmprParam : nmprParamList) {
			nmprParam.put("GOODS_CODE", newGoodsCode);
			goodsNmprDAO.insertGoodsNmpr(nmprParam);
		}
	}

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

		return newGoodsCode;
	}

	@Override
	public int updateGoods(Map<String, Object> params) throws Exception {
		// 상품
		Map<String, String> goodsParam = (Map<String, String>)params.get("goodsParam");
		UserUtils.log("[modGoods][상품]", goodsParam);
		int iGoods = goodsDAO.updateGoods(goodsParam);

		Map<String, String> map = new HashMap<String, String>();
		map.put("GOODS_CODE", UserUtils.nvl(goodsParam.get("GOODS_CODE")));
		map.put("FILE_CODE", UserUtils.nvl(goodsParam.get("FILE_CODE")));
		map.put("UPDT_ID", UserUtils.nvl(goodsParam.get("UPDT_ID")));
		String sGoodsCode = UserUtils.nvl(goodsParam.get("GOODS_CODE"));

		// 파일
		List<Map<String, String>> fileParamList = (List<Map<String, String>>)params.get("fileParamList");
		// TODO 파일 삭제 처리
		//fileManageDAO.deleteFileDetailInfos(map);
		// 대표이미지 있는지 확인
		int iCnt = fileManageDAO.selectFileReprsntCnt(map);
		LOG.debug("[modGoods-대표이지미체크]iCnt:"+iCnt);
		for(int i = 0 ; i < fileParamList.size() ; i++) {
			Map<String, String> fileParam = (Map<String, String>)fileParamList.get(i);
			if(iCnt == 0 && i == 0) {
				fileParam.put("REPRSNT_AT", "Y");
			}
			fileManageDAO.insertFileDetail(fileParam);
		}

		// 상품 분류
		List<Map<String, String>> clParamList = (List<Map<String, String>>)params.get("clParamList");
		goodsClDAO.deleteGoodsCl(map);
		for(Map<String, String> clParam : clParamList) {
			clParam.put("GOODS_CODE", sGoodsCode);
			goodsClDAO.insertGoodsCl(clParam);
		}

		// 상품 일정
		List<Map<String, String>> schdulParamList = (List<Map<String, String>>)params.get("schdulParamList");
		goodsSchdulDAO.deleteGoodsSchdulInfos(map);
		for(Map<String, String> schdulParam : schdulParamList) {
			schdulParam.put("GOODS_CODE", sGoodsCode);
			goodsSchdulDAO.insertGoodsSchdul(schdulParam);
		}

		// 상품 시간
		List<Map<String, String>> timeParamList = (List<Map<String, String>>)params.get("timeParamList");
		goodsTimeDAO.deleteGoodsTime(map);
		for(Map<String, String> timeParam : timeParamList) {
			timeParam.put("GOODS_CODE", sGoodsCode);
			goodsTimeDAO.insertGoodsTime(timeParam);
		}

		// 상품 인원
		List<Map<String, String>> nmprParamList = (List<Map<String, String>>)params.get("nmprParamList");
		goodsNmprDAO.deleteGoodsNmpr(map);
		for(Map<String, String> nmprParam : nmprParamList) {
			nmprParam.put("GOODS_CODE", sGoodsCode);
			goodsNmprDAO.insertGoodsNmpr(nmprParam);
		}

		return 0;
	}

	@Override
	public int updateGoodsForBass(Map<String, String> param) throws Exception {
		int iRe = goodsDAO.updateGoodsForBass(param);

		if(iRe == 0) {
			throw new Exception("기본정보 수정 중 오류 발생!");
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
	public List<Map<String, String>> selectGoodsListForSearch(Map<String, String> param) throws Exception {
		return goodsDAO.selectGoodsListForSearch(param);
	}

	@Override
	public List<Map<String, String>> selectGoodsClList(Map<String, String> param) throws Exception {
		return goodsClDAO.selectGoodsClList(param);
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
}
