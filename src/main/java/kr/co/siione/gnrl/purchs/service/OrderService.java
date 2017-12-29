package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

public interface OrderService {
	public HashMap getCartDetail(HashMap map) throws Exception;
	public List<HashMap> getCartDetailList(HashMap map) throws Exception;
	public int chkSchedule(HashMap map)throws Exception;
	public int chkFlight(HashMap map)throws Exception;
	public void setFlight(HashMap map) throws Exception;
	public void addPurchs(HashMap map) throws Exception;
	public List<HashMap> getCartPurchsList(HashMap map) throws Exception;
	public HashMap getPurchs(HashMap map) throws Exception;
}
