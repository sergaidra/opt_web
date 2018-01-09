package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("TourClDAO")
public class TourClDAO extends EgovComAbstractDAO {
	
	public Object insertTourCl(Map<String, String> map) throws Exception {
		return insert("TourClDAO.insertTourCl", map);
	}

	public int updateTourCl(Map<String, String> map) throws Exception {
		return update("TourClDAO.updateTourCl", map);
	}
	
	public int deleteTourCl(Map<String, String> map) throws Exception {
		return delete("TourClDAO.deleteTourCl", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> selectTourClByPk(Map<String, String> param) throws Exception {
		return (Map<String, String>) selectByPk("TourClDAO.selectTourClByPk", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourClList(Map<String, String> param) throws Exception {
		return list("TourClDAO.selectTourClList", param);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourClTree(Map<String, String> param) throws Exception {
		return list("TourClDAO.selectTourClTree", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourClUpperList(Map<String, String> param) throws Exception {
		return list("TourClDAO.selectTourClUpperList", param);
	}	
	
    public int selectTourClFileCnt(Map<String, String> param) throws Exception{
        return (Integer)selectByPk("TourClDAO.selectTourClFileCnt", param);
    }
    
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectTourClCombo(Map<String, String> param) throws Exception {
		return list("TourClDAO.selectTourClCombo", param);
	}	    
}
