package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.PurchsService;

@Service("PurchsService")
public class PurchsServiceImpl implements PurchsService {

	@Resource(name = "purchsDAO")
	private PurchsDAO purchsDAO;
	
	@Resource(name = "pointDAO")
	private PointDAO pointDAO;
		
	public int getPurchsListCount(HashMap map) throws Exception {
		return purchsDAO.getPurchsListCount(map);
	}
		
    public List<HashMap> getPurchsList(HashMap map) throws Exception {
        return purchsDAO.getPurchsList(map);
    }
    
    public List<HashMap> getPurchsCartList(HashMap map) throws Exception {
    	return purchsDAO.getPurchsCartList(map);
    }
    
	public List<HashMap> selectPurchsDetail(HashMap map) throws Exception {
		return purchsDAO.selectPurchsDetail(map);
	}
	
	public void cancelPurchs(HashMap map) throws Exception {
		purchsDAO.cancelPurchs(map);
	}
	
	public HashMap viewPurchs(HashMap map) throws Exception {
		return purchsDAO.viewPurchs(map);
	}
	
	public List<HashMap> getOrderInfoGoodsTime(HashMap map) throws Exception {
		return purchsDAO.getOrderInfoGoodsTime(map);
	}
	
}
