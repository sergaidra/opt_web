package kr.co.siione.mngr.service.impl;

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
import kr.co.siione.utl.UserUtils;

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
		//fileManageDAO.deleteFileDetail(map);
		// 대표이미지 있는지 확인
		int iCnt = fileManageDAO.selectFileReprsntCnt(map);
		System.out.println("[modGoods-대표이지미체크]iCnt:"+iCnt);
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
		goodsSchdulDAO.deleteGoodsSchdul(map);
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
	public int deleteGoods(Map<String, String> param) throws Exception {
		return goodsDAO.deleteGoods(param);
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
}
