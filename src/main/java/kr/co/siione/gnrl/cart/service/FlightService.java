package kr.co.siione.gnrl.cart.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FlightService {
    public void addFlight(HashMap map) throws Exception;
    public int updateFlight(HashMap map) throws Exception; 
    public int deleteFlight(HashMap map) throws Exception; 
    public HashMap getFlightDetail(HashMap map) throws Exception;
    public List<HashMap> getArlineSchdulList(Map<String, String> map) throws Exception;
}
