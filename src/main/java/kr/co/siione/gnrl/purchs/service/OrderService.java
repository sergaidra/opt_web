package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

public interface OrderService {
	public HashMap getCartDetail(HashMap map) throws Exception;
	public List<HashMap> getCartDetailList(HashMap map) throws Exception;
	public int chkSchedule(HashMap map)throws Exception;
	public void addPurchs(HashMap map) throws Exception;
}
