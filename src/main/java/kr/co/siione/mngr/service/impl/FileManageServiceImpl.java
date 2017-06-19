package kr.co.siione.mngr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.siione.mngr.service.FileManageService;

@Service("FileManageService")
public class FileManageServiceImpl implements FileManageService {
	
	@Resource(name = "FileManageDAO")
	private FileManageDAO fileManageDAO;

	@Override
	public List<Map<String, String>> selectFileDetailList(Map<String, String> param) throws Exception {
		return fileManageDAO.selectFileDetailList(param);
	}

}
