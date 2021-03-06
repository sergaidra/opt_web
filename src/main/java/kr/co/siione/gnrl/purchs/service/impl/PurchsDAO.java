package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class PurchsDAO extends EgovComAbstractDAO {
	public int getPurchsListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.purchs.selectPurchsListCount", map);
	}

	public List<HashMap> getPurchsList(HashMap map) throws Exception {
		return list("gnrl.purchs.selectPurchsList", map);
	}
	
	public List<HashMap> getPurchsCartList(HashMap map) throws Exception {
		return list("gnrl.purchs.selectPurchsCartList", map);
	}	

	public List<HashMap> selectPurchsDetail(HashMap map) throws Exception {
		return list("gnrl.purchs.selectPurchsDetail", map);
	}

	public HashMap viewPurchs(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.purchs.viewPurchs", map);
	}
	
	public List<HashMap> getOrderInfoGoodsTime(HashMap map) throws Exception {
		return list("gnrl.purchs.getOrderInfoGoodsTime", map);
	}

	public List<HashMap> getCartInfoGoodsTime(HashMap map) throws Exception {
		return list("gnrl.purchs.getCartInfoGoodsTime", map);
	}
}
