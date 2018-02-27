package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.utl.UserUtils;

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

    public void usePoint(HashMap map) throws Exception {
    	int use_point = Integer.valueOf(String.valueOf(map.get("use_point")));
    	String point_purchs_sn = String.valueOf(map.get("purchs_sn"));
    	String esntl_id = String.valueOf(map.get("esntl_id"));
    	List<HashMap> lst = pointDAO.getMyUsePoint(map);
    	
    	for(int i = 0; i < lst.size(); i++) {
    		String purchs_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("PURCHS_SN")));
    		String cart_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("CART_SN")));
    		String point_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("POINT_SN")));
    		int point = Integer.valueOf(String.valueOf(lst.get(i).get("POINT")));
    		int this_use_point = 0;
    		
    		if(use_point > point)
    			this_use_point = point;
    		else
    			this_use_point = use_point;
    		
    		HashMap mapPoint = new HashMap();
    		mapPoint.put("esntl_id", esntl_id);
    		mapPoint.put("purchs_sn", purchs_sn);
    		mapPoint.put("cart_sn", cart_sn);
    		mapPoint.put("point_sn", point_sn);
    		mapPoint.put("point", this_use_point);
    		mapPoint.put("point_purchs_sn", point_purchs_sn);
    		mapPoint.put("accml_se", "A");
    		
    		if("".equals(point_sn)) {
        		pointDAO.updateUsePoint(mapPoint);
        		pointDAO.insertPointHistory(mapPoint);
    		} else {
        		pointDAO.updateUsePoint2(mapPoint);
        		pointDAO.insertPointHistory(mapPoint);
    		}
    		
    		use_point -= this_use_point;
    		if(use_point <= 0)
    			break;
    	}
    }
    
    public void cancelPoint(HashMap map) throws Exception {
    	//int cancel_point = Integer.valueOf(String.valueOf(map.get("cancel_point")));
    	int cancel_point = pointDAO.getPurchsPoint(map);
    	if(cancel_point == 0)
    		return;
    	String point_purchs_sn = String.valueOf(map.get("purchs_sn"));
    	String esntl_id = String.valueOf(map.get("esntl_id"));
    	List<HashMap> lst = pointDAO.getMyLastUsePoint(map);
    	
    	for(int i = 0; i < lst.size(); i++) {
    		String purchs_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("PURCHS_SN")));
    		String cart_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("CART_SN")));
    		String point_sn = UserUtils.nvl(String.valueOf(lst.get(i).get("POINT_SN")));
    		//int point = Integer.valueOf(String.valueOf(lst.get(i).get("POINT")));
    		int use_point = Integer.valueOf(String.valueOf(lst.get(i).get("USE_POINT")));
    		int this_use_point = 0;
    		
    		if(use_point > cancel_point)
    			this_use_point = cancel_point;
    		else
    			this_use_point = use_point;
    		
    		HashMap mapPoint = new HashMap();
    		mapPoint.put("esntl_id", esntl_id);
    		mapPoint.put("purchs_sn", purchs_sn);
    		mapPoint.put("cart_sn", cart_sn);
    		mapPoint.put("point_sn", point_sn);
    		mapPoint.put("point", this_use_point);
    		mapPoint.put("point_purchs_sn", point_purchs_sn);
    		mapPoint.put("accml_se", "C");
    		
    		if("".equals(point_sn)) {
    			pointDAO.updateCancelPoint(mapPoint);
    			pointDAO.insertPointHistory(mapPoint);
    		} else {
        		pointDAO.updateCancelPoint2(mapPoint);
        		pointDAO.insertPointHistory2(mapPoint);
    		}
    		
    		cancel_point -= this_use_point;
    		if(cancel_point <= 0)
    			break;
    	}
    }
}
