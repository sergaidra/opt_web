package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.gnrl.purchs.service.PurchsService;

@Service("OrderService")
public class OrderServiceImpl implements OrderService {

	@Resource(name = "orderDAO")
	private OrderDAO orderDAO;
	
	public HashMap getCartDetail(HashMap map) throws Exception {
		return orderDAO.getCartDetail(map);
	}
	
	public List<HashMap> getCartDetailList(HashMap map) throws Exception {
		return orderDAO.getCartDetailList(map);
	}

	public HashMap chkSchedule(HashMap map)throws Exception {
		return orderDAO.chkSchedule(map);
	}

	public void addPurchs(HashMap map) throws Exception {
		int purchs_sn = orderDAO.selectPurchsSn(map);
		map.put("purchs_sn", purchs_sn);
		orderDAO.insertPurchs(map);

		List<HashMap> nList = (List<HashMap>) map.get("lstCart");
		for(HashMap nMap:nList) {
			nMap.put("purchs_sn", purchs_sn);
			orderDAO.insertPurchsGoods(nMap);
			orderDAO.updCartGoods(nMap);
		}
	}

}

