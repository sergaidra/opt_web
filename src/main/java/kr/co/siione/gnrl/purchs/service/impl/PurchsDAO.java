package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class PurchsDAO extends EgovComAbstractDAO {
    public int selectPurchsSn(HashMap map) throws Exception{
        return (Integer)selectByPk("gnrl.purchs.selectPurchsSn", map);
    }	
	
    public int getTotalPoint(HashMap map) throws Exception {
    	return (Integer)selectByPk("gnrl.purchs.getTotalPoint", map);
    }
    
    public void insertPurchs(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchs", map);
    }
	
    public void insertPurchsGoods(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchsGoods", map);
    }
    
    public void updCartGoods(HashMap map) throws Exception {
		update("gnrl.purchs.updCartGoods", map);
    }
    
	public int getPurchsListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.purchs.selectPurchsListCount", map);
	}

	public List<HashMap> getPurchsList(HashMap map) throws Exception {
		return list("gnrl.purchs.selectPurchsList", map);
	}
	
	public List<HashMap> selectPurchsDetail(HashMap map) throws Exception {
		return list("gnrl.purchs.selectPurchsDetail", map);
	}

    public void insertPurchsReview(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchsReview", map);
    }

    public void updatePurchsReview(HashMap map) throws Exception {
		insert("gnrl.purchs.updatePurchsReview", map);
    }

	public HashMap selectPurchsReview(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.purchs.selectPurchsReview", map);
	}

    public void insertPurchsPoint(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchsPoint", map);
    }

	public HashMap selectPurchsPoint(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.purchs.selectPurchsPoint", map);
	}

}
