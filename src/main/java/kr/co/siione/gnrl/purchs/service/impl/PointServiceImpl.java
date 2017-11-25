package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;

@Service("PointService")
public class PointServiceImpl implements PointService {

	@Resource(name = "pointDAO")
	private PointDAO pointDAO;

	public int getTotalPoint(HashMap map) throws Exception {
    	return pointDAO.getTotalPoint(map);
    }

	public int getPointListCount(HashMap map) throws Exception {
		return pointDAO.getPointListCount(map);
	}
		
    public List<HashMap> getPointList(HashMap map) throws Exception {
        return pointDAO.getPointList(map);
    }

}
