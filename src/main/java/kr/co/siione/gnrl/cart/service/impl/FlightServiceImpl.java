package kr.co.siione.gnrl.cart.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cart.service.FlightService;

@Service("FlightService")
public class FlightServiceImpl implements FlightService {

	@Resource(name = "flightDAO")
	private FlightDAO flightDAO;

	public void addFlight(HashMap map) throws Exception {
		flightDAO.insertFlight(map);
	}

	public int updateFlight(HashMap map) throws Exception {
		return flightDAO.updateFlight(map);
	}
	
	public int deleteFlight(HashMap map) throws Exception {
		return flightDAO.deleteFlight(map);
	}

	public HashMap getFlightDetail(HashMap map) throws Exception{
		return flightDAO.getFlightDetail(map);
	}

	public List<HashMap> getArlineSchdulList(Map<String, String> map) throws Exception {
		return flightDAO.getArlineSchdulList(map);
	}
	
	
}
