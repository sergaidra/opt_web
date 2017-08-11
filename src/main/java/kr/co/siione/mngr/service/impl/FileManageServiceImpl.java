package kr.co.siione.mngr.service.impl;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.FileManageDAO;
import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.utl.UserUtils;

import org.springframework.stereotype.Service;

@Service("FileManageService")
public class FileManageServiceImpl implements FileManageService {
	
	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;

	@Override
	public List<Map<String, String>> selectFileDetailList(Map<String, String> param) throws Exception {
		return fileManageDAO.selectFileDetailList(param);
	}
	
	@Override
	public Map<String, String> selectFileDetail(Map<String, String> param) throws Exception {
		return fileManageDAO.selectFileDetailByPk(param);
	}
	
	@Override
	public int deleteFileDetail(Map<String, String> param) throws Exception {
		
		Map<String, String> mapFile = fileManageDAO.selectFileDetailByPk(param);

		File file = new File(UserUtils.nvl(mapFile.get("FILE_PATH")));
		
		if(file.delete()) {
			return fileManageDAO.deleteFileDetail(param);	
		} else {
			return 0;
		}
	}
}
