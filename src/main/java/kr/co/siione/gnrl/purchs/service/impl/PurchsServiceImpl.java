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
	
	public void addPurchs(HashMap map) throws Exception {
		int purchs_sn = purchsDAO.selectPurchsSn(map);
		map.put("purchs_sn", purchs_sn);
		purchsDAO.insertPurchs(map);

		List<HashMap> nList = (List<HashMap>) map.get("lstCart");
		for(HashMap nMap:nList) {
			nMap.put("purchs_sn", purchs_sn);
			purchsDAO.insertPurchsGoods(nMap);
			purchsDAO.updCartGoods(nMap);
		}
	}
		
	public int getPurchsListCount(HashMap map) throws Exception {
		return purchsDAO.getPurchsListCount(map);
	}
		
    public List<HashMap> getPurchsList(HashMap map) throws Exception {
        return purchsDAO.getPurchsList(map);
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
	
	public HashMap chkSchedule(HashMap map)throws Exception {
		return purchsDAO.chkSchedule(map);
	}
}
