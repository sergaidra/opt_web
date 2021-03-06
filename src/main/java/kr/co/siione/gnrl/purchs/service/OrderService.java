package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

public interface OrderService {
	public HashMap getCartDetail(HashMap map) throws Exception;
	public List<HashMap> getCartDetailList(HashMap map) throws Exception;
	public int chkSchedule(HashMap map)throws Exception;
	public int chkFlight(HashMap map)throws Exception;
	public void setFlight(HashMap map) throws Exception;
	public String addPurchs(HashMap map, HashMap mapPay) throws Exception;
	public List<HashMap> getCartPurchsList(HashMap map) throws Exception;
	public HashMap getPurchs(HashMap map) throws Exception;
	public HashMap getPay(HashMap map) throws Exception;
	public List<HashMap> getCode(HashMap map) throws Exception;
	public HashMap getCancelRefundAmount(HashMap map) throws Exception;
	public void cancelPurchs(HashMap map) throws Exception;
	public void updateStatus(HashMap map) throws Exception;
	public HashMap getPayPre(HashMap map) throws Exception;
	public void updateNoti(HashMap mapPurchs, HashMap mapPay) throws Exception;
	public HashMap getPurchInfoSession(HttpSession session);
	public List<HashMap> getPastVBank(HashMap map) throws Exception;
	public HashMap getReservationStatus(HashMap map) throws Exception;
	public void updateReservationStatus(HashMap map) throws Exception;
	public Double getExchangeRate(HashMap map) throws Exception;
}
