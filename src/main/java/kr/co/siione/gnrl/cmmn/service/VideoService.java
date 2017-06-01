package kr.co.siione.gnrl.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface VideoService {
	public String getFileID() throws Exception;
	public String getFileNo(HashMap map) throws Exception;
	public void fileUpload(HashMap map) throws Exception;
	public void thumbUpload(HashMap map) throws Exception;
	public List getFileList(HashMap map) throws Exception;
	public List getThumbList(HashMap map) throws Exception;
	public HashMap getFileDetail(HashMap map) throws Exception;
	public HashMap getThumbDetail(HashMap map) throws Exception;
	public void thumbDelete(HashMap map) throws Exception;
	public void thumbReprsnt(HashMap map) throws Exception;
	
}
