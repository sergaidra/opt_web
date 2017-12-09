package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class FlightDAO extends EgovComAbstractDAO {

    public HashMap selectLastFlight(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cmmn.selectLastFlight", map);
    }
	
    public List selectCurrentFlight(HashMap map) throws Exception {
        return list("gnrl.cmmn.selectCurrentFlight", map);
    }
    
    public int selectFlightSn() throws Exception {
        return (Integer)selectByPk("gnrl.cmmn.selectFlightSn", null);
    }
    
    public void insertFlight(HashMap map) throws Exception {
        insert("gnrl.cmmn.insertFlight", map);
    }
    
    public void updateFlight(HashMap map) throws Exception {
        update("gnrl.cmmn.updateFlight", map);
    }
    
    public void initFlight(HashMap map) throws Exception {
        update("gnrl.cmmn.initFlight", map);
    }   
    

}
