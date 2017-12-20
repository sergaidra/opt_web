package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class CancelDAO extends EgovComAbstractDAO {
   
	public int getCancelListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.cancel.selectCancelListCount", map);
	}

	public List<HashMap> getCancelList(HashMap map) throws Exception {
		return list("gnrl.cancel.selectCancelList", map);
	}	
	
	public List<HashMap> getPurchsCartList(HashMap map) throws Exception {
		return list("gnrl.cancel.selectPurchsCartList", map);
	}	
	
	

}
