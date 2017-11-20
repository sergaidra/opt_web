package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("PointDAO")
public class PointDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPointList(Map<String, String> param) throws Exception {
		return list("PointDAO.selectPointList", param);
	}
	
	public int selectPointListCount(Map<String, String> param) throws Exception {
		return (Integer)selectByPk("PointDAO.selectPointListCount", param);
	}
}
