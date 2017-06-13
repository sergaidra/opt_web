package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cmmn.service.FileService;

@Service("FileService")
public class FileServiceImpl implements FileService {

	@Resource(name = "fileDAO")
	private FileDAO fileDAO;

    public List<HashMap> getFileList(HashMap map) throws Exception {
        return fileDAO.selectFileList(map);
    }

    public HashMap getFileDetail(HashMap map) throws Exception {
        return fileDAO.selectFileDetail(map);
    }
}
