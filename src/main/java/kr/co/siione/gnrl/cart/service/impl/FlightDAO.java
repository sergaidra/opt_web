package kr.co.siione.gnrl.cart.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class FlightDAO extends EgovComAbstractDAO {
	
	public void insertFlight(HashMap map) throws Exception {
		insert("gnrl.cart.insertFlight", map);
    }
    
	public int updateFlight(HashMap map) throws Exception {
		return update("gnrl.cart.updateFlight", map);
	}  
	
	public int deleteFlight(HashMap map) throws Exception {
		return update("gnrl.cart.deleteFlight", map);
	} 
	
	public HashMap getFlightDetail(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.cart.selectFlightDetail", map);
	}
	
	public List getArlineSchdulList(Map<String, String> map) throws Exception {
		return list("gnrl.cart.selectArlineSchdulList", map);
	}
	
}
