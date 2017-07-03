package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
	public int updateGoods(Map<String, String> param) throws Exception {
		int cnt = goodsDAO.updateGoods(param);
		
		if(cnt == 1) {
			// 파일삭제
			List<Map<String, String>> files = fileManageDAO.selectFileDetailList(param);
			
			for(Map<String, String> fileInfo : files) {
				File file = new File(fileInfo.get("FILE_PATH").toString());
				file.delete();
			}
			
			if(fileManageDAO.deleteFileDetail(param) > 0) {
				fileManageDAO.insertFileDetail(param);
			} else {
				throw new Exception("파일 삭제 중 오류 발생");
			}
		} else {
			throw new Exception("상품 수정 중 오류 발생");
		}
		
		return cnt;
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

}
