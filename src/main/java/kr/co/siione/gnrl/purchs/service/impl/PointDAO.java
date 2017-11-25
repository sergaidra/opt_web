package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class PointDAO extends EgovComAbstractDAO {
    public int getTotalPoint(HashMap map) throws Exception {
    	return (Integer)selectByPk("gnrl.point.getTotalPoint", map);
    }
    
    public void insertPoint(HashMap map) throws Exception {
		insert("gnrl.point.insertPoint", map);
    }

	public int getPointListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.point.selectPointListCount", map);
	}

	public List<HashMap> getPointList(HashMap map) throws Exception {
		return list("gnrl.point.selectPointList", map);
	}

}
