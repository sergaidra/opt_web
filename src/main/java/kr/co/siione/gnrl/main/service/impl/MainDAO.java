package kr.co.siione.gnrl.main.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class MainDAO extends EgovComAbstractDAO {

	public List selectMainImageList() throws Exception {
		return list("gnrl.main.selectMainImageList");
	}
	
	public List getMySchedule(HashMap map) throws Exception {
		return list("gnrl.main.getMySchedule", map);
	}
	
	public List getMyScheduleRoom(HashMap map) throws Exception {
		return list("gnrl.main.getMyScheduleRoom", map);
	}
	
	
	public List getBanner(HashMap map) throws Exception {
		return list("gnrl.main.getBanner", map);
	}
}
