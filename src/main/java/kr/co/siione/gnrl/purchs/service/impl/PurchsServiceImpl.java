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
	
	public int getTotalPoint(HashMap map) throws Exception {
    	return purchsDAO.getTotalPoint(map);
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

    public void insertPurchsReview(HashMap map) throws Exception {
		HashMap review = purchsDAO.selectPurchsReview(map);
		HashMap point = purchsDAO.selectPurchsPoint(map);
		if(review == null)
			purchsDAO.insertPurchsReview(map);
		else
			purchsDAO.updatePurchsReview(map);
		if("Y".equals(map.get("pointYn")) && point == null)
			purchsDAO.insertPurchsPoint(map);
    }
    
	public HashMap selectPurchsReview(HashMap map) throws Exception {
		return purchsDAO.selectPurchsReview(map);
	}
}
