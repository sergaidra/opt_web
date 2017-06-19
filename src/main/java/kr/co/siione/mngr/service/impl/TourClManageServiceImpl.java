package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.service.TourClManageService;

import org.springframework.stereotype.Service;

@Service("TourClManageService")
public class TourClManageServiceImpl implements TourClManageService {

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
			
			if(fileManageDAO.deleteFileDetail(param) > 0) {
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
	public Map<String, String> selectTourClByPk(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClByPk(param);
	}
	
	@Override
	public List<Map<String, String>> selectTourClList(Map<String, String> param) throws Exception {
		return tourClDAO.selectTourClList(param);
	}

}
