package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import kr.co.siione.gnrl.cmmn.service.VideoService;

@Service("VideoService")
public class VideoServiceImpl implements VideoService {

	@Resource(name = "videoDAO")
	private VideoDAO videoDAO;

	public String getFileID() throws Exception{
		return videoDAO.selectFileID();	
	}

	public String getFileNo(HashMap map) throws Exception{
		return videoDAO.selectFileNo(map);	
	}

    public void fileUpload(HashMap map) throws Exception {
		videoDAO.insertFile(map);
		List<HashMap> thumbList = (List) map.get("thumbList");
		for(HashMap sMap:thumbList) {
			videoDAO.insertThumb(sMap);
		}
    }

    public void thumbUpload(HashMap map) throws Exception {
		videoDAO.insertThumb(map);
    }

	public List getFileList(HashMap map) throws Exception{
		return videoDAO.selectFileList(map);
	}
	
	public List getThumbList(HashMap map) throws Exception {
		return videoDAO.selectThumbList(map);
	}

	public HashMap getFileDetail(HashMap map) throws Exception{
		return videoDAO.selectFileDetail(map);
	}
	
	public HashMap getThumbDetail(HashMap map) throws Exception{
		return videoDAO.selectThumbDetail(map);
	}
	
	public void thumbDelete(HashMap map) throws Exception{
		videoDAO.deleteThumb(map);
	}
	public void thumbReprsnt(HashMap map) throws Exception{
		//기존 대표 리셋
		HashMap insMap = new HashMap();
		insMap.put("reprsnt_yn", "N");
		insMap.put("file_id", map.get("file_id"));
		insMap.put("file_no", map.get("file_no"));
		videoDAO.updateThumb(insMap);
		
		//대표 설정
		map.put("reprsnt_yn", "Y");
		videoDAO.updateThumb(map);		
	}

}
