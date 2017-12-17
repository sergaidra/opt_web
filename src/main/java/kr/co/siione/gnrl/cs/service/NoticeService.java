package kr.co.siione.gnrl.cs.service;

import java.util.HashMap;
import java.util.List;

public interface NoticeService {
	public void insertBbs(HashMap map) throws Exception;	
	public void deleteBbs(HashMap map) throws Exception;
	public void updateBbs(HashMap map) throws Exception;	
	public HashMap viewBbs(HashMap map) throws Exception;
	public List<HashMap> mainNoticelist(HashMap map) throws Exception;
	public HashMap mainPopupNotice(HashMap map) throws Exception;

}
