package kr.co.siione.gnrl.main.service;

import java.util.HashMap;
import java.util.List;

public interface MainService {
	public List<HashMap> getMainImageList() throws Exception;
	public List getMySchedule(HashMap map) throws Exception;
}
