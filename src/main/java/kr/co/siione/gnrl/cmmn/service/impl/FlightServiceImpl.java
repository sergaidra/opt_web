package kr.co.siione.gnrl.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cmmn.service.ExcelService;
import kr.co.siione.gnrl.cmmn.service.FlightService;

@Service("FlightService")
public class FlightServiceImpl implements FlightService {

	@Resource(name = "flightDAO")
	private FlightDAO flightDAO;

	public HashMap selectLastFlight(HashMap map) throws Exception {
		return flightDAO.selectLastFlight(map);
	}
	
    public List selectCurrentFlight(HashMap map) throws Exception {
    	return flightDAO.selectCurrentFlight(map);
    }
    
    public HashMap getFlight(HashMap map) throws Exception {
    	return flightDAO.getFlight(map);
    }

    public void insertFlight(HashMap map) throws Exception {
    	if(map.containsKey("flight_sn") && !"".equals(map.get("flight_sn"))) {
    		flightDAO.updateFlight(map);
    	} else {
    		int flight_sn = flightDAO.selectFlightSn();
    		map.put("flight_sn", flight_sn);
    		flightDAO.insertFlight(map);
    	}
    }
    
    public void initFlight(HashMap map) throws Exception {
    	flightDAO.initFlight(map);
    }
}
