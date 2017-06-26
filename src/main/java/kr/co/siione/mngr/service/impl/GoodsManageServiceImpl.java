package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.service.GoodsManageService;

import org.springframework.stereotype.Service;

@Service("GoodsManageService")
public class GoodsManageServiceImpl implements GoodsManageService {

	@Resource(name = "GoodsDAO")
	private GoodsDAO tourClDAO;

	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;
	
	@Override
	public void insertGoods(Map<String, String> param) throws Exception {
		Object fileCode = fileManageDAO.insertFileManage(param);
		param.put("FILE_CODE", String.valueOf(fileCode));
		fileManageDAO.insertFileDetail(param);
		tourClDAO.insertGoods(param);
	}

	@Override
	public int updateGoods(Map<String, String> param) throws Exception {
		int cnt = tourClDAO.updateGoods(param);
		
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
		return tourClDAO.deleteGoods(param);
	}

	@Override
	public Map<String, String> selectGoodsByPk(Map<String, String> param) throws Exception {
		return tourClDAO.selectGoodsByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectGoodsList(Map<String, String> param) throws Exception {
		return tourClDAO.selectGoodsList(param);
	}

}
