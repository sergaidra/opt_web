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
	
    public void insertPurchs(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchs", map);
    }
	
    public void insertPurchsGoods(HashMap map) throws Exception {
		insert("gnrl.purchs.insertPurchsGoods", map);
    }
}
