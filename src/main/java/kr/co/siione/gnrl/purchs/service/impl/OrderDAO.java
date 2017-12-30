package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class OrderDAO extends EgovComAbstractDAO {
	public HashMap getCartDetail(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.order.selectCartDetail", map);
	}

	public List<HashMap> getCartDetailList(HashMap map) throws Exception {
		return list("gnrl.order.selectCartDetailList", map);
	}

	public int chkSchedule(HashMap map)throws Exception {
		return (Integer)selectByPk("gnrl.order.chkSchedule", map);
	} 

	public int chkFlight(HashMap map)throws Exception {
		return (Integer)selectByPk("gnrl.order.chkFlight", map);
	} 
	
    public void setFlight(HashMap map) throws Exception {
		insert("gnrl.order.setFlight", map);
    }	

    public int selectPurchsSn(HashMap map) throws Exception{
        return (Integer)selectByPk("gnrl.order.selectPurchsSn", map);
    }	
	
    public void insertPurchs(HashMap map) throws Exception {
		insert("gnrl.order.insertPurchs", map);
    }
	
    public void insertPurchsGoods(HashMap map) throws Exception {
		insert("gnrl.order.insertPurchsGoods", map);
    }
    
    public void updCartGoods(HashMap map) throws Exception {
		update("gnrl.order.updCartGoods", map);
    }
    
    public void insertReservationDay(HashMap map) throws Exception {
		insert("gnrl.order.insertReservationDay", map);
    }

	public List<HashMap> getCartPurchsList(HashMap map) throws Exception {
		return list("gnrl.order.getCartPurchsList", map);
	}

	public HashMap getPurchs(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.order.getPurchs", map);
	}

}