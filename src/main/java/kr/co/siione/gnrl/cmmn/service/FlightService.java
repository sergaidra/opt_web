package kr.co.siione.gnrl.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface FlightService {
	public List selectCurrentFlight(HashMap map) throws Exception;
	public void insertFlight(HashMap map) throws Exception;
}
