package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("MainImageDAO")
public class MainImageDAO extends EgovComAbstractDAO {

	public Object insertMainImage(Map<String, String> map) throws Exception {
		return insert("MainImageDAO.insertMainImage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectMainImageList(Map<String, String> param) throws Exception {
		return list("MainImageDAO.selectMainImageList", param);
	}
	
	public int updateMainImage(Map<String, String> map) throws Exception {
		return update("MainImageDAO.updateMainImage", map);
	}
}
