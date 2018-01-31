package kr.co.siione.gnrl.purchs.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.utl.MailManager;

@Service("OrderService")
@PropertySource("classpath:property/globals.properties")
public class OrderServiceImpl implements OrderService {

	@Resource(name = "orderDAO")
	private OrderDAO orderDAO;
	
	@Resource
    private	MailManager mailManager;
	
	@Resource
    private PointService pointService;
	
	@Value("#{globals['server.ip']}")
	private String webserverip;
	@Value("#{globals['server.domain']}")
	private String webserverdomain;

	public HashMap getCartDetail(HashMap map) throws Exception {
		return orderDAO.getCartDetail(map);
	}
	
	public List<HashMap> getCartDetailList(HashMap map) throws Exception {
		return orderDAO.getCartDetailList(map);
	}

	public int chkSchedule(HashMap map)throws Exception {
		return orderDAO.chkSchedule(map);
	}
	
	public int chkFlight(HashMap map)throws Exception {
		return orderDAO.chkFlight(map);
	}
	
	public void setFlight(HashMap map) throws Exception {
		orderDAO.setFlight(map);
	}
	
	private String getHtml(String filename) {
		StringBuilder builder = new StringBuilder();
		org.springframework.core.io.Resource resource = new ClassPathResource("html/" + filename); 
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(resource.getInputStream(), "UTF-8"));
			String line = null;
            while ((line = reader.readLine()) != null)
                builder.append(line);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return builder.toString();
	}	

	public String addPurchs(HashMap map, HashMap mapPay) throws Exception {
		int purchs_sn = orderDAO.selectPurchsSn(map);
		map.put("purchs_sn", purchs_sn);
		orderDAO.insertPurchs(map);

		List<HashMap> nList = (List<HashMap>) map.get("lstCart");
		for(HashMap nMap:nList) {
			nMap.put("purchs_sn", purchs_sn);
			orderDAO.insertPurchsGoods(nMap);
			orderDAO.updCartGoods(nMap);
			orderDAO.insertReservationDay(nMap);
		}
		
		//포인트 사용
		if(map.get("use_point") != null) {
			String strPoint = String.valueOf(map.get("use_point"));
			if(!"".equals(strPoint) && !"0".equals(strPoint)) {
				int point = Integer.valueOf(strPoint);
				HashMap mapPoint = new HashMap();
				mapPoint.put("use_point", point);
				mapPoint.put("purchs_sn", purchs_sn);
				mapPoint.put("esntl_id", String.valueOf(map.get("esntl_id")));
				pointService.usePoint(mapPoint);
			}
		}
		
		if(mapPay != null) {
			mapPay.put("purchs_sn", purchs_sn);
			orderDAO.insertPay(mapPay);
		}
		
		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());
		String subject = "원패스투어 결제내역입니다.";
		String content = getHtml("mail.htm");
		String order = getHtml("order.htm");
		String orderitem = getHtml("orderitem.htm");
		String orderlist = "";
		
		List<HashMap> lstCartPurchs = getCartPurchsList(map);		
			for(int i = 0; i < lstCartPurchs.size(); i++) {
				map.put("cart_sn", lstCartPurchs.get(i).get("CART_SN"));
				HashMap mapCart = getCartDetail(map);
				String str = orderitem;
				String date = "";
				String options = "";
				
				date = String.valueOf(mapCart.get("GOODS_DATE"));
				options = String.valueOf(mapCart.get("GOODS_TIME"));
				if(!"".equals(options))
					options += "<br/>";
				options += String.valueOf(mapCart.get("GOODS_OPTION"));

				str = str.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);
				str = str.replaceAll("[$]\\{file_code\\}", String.valueOf(mapCart.get("FILE_CODE")));
				str = str.replaceAll("[$]\\{goods_nm\\}", String.valueOf(mapCart.get("GOODS_NM")));
				str = str.replaceAll("[$]\\{date\\}", date);
				str = str.replaceAll("[$]\\{options\\}", options);
				str = str.replaceAll("[$]\\{item_amount\\}", String.format("%,d", Integer.valueOf(String.valueOf(mapCart.get("ORIGIN_AMOUNT")))));
				
				if(lstCartPurchs.get(i).get("PICKUP_PLACE") != null && !"".equals(String.valueOf(lstCartPurchs.get(i).get("PICKUP_PLACE")))) {
					str = str.replaceAll("[$]\\{pickup_place\\}", String.valueOf(lstCartPurchs.get(i).get("PICKUP_PLACE")));
					str = str.replaceAll("[$]\\{pickup_place_display\\}", "block");
				} else {
					str = str.replaceAll("[$]\\{pickup_place\\}", "");
					str = str.replaceAll("[$]\\{pickup_place_display\\}", "none");
				}
				if(lstCartPurchs.get(i).get("DROP_PLACE") != null && !"".equals(String.valueOf(lstCartPurchs.get(i).get("DROP_PLACE")))) {
					str = str.replaceAll("[$]\\{drop_place\\}", String.valueOf(lstCartPurchs.get(i).get("DROP_PLACE")));
					str = str.replaceAll("[$]\\{drop_place_display\\}", "block");
				} else {
					str = str.replaceAll("[$]\\{drop_place\\}", "");
					str = str.replaceAll("[$]\\{drop_place_display\\}", "none");
				}
				if(lstCartPurchs.get(i).get("USE_NMPR") != null && !"".equals(String.valueOf(lstCartPurchs.get(i).get("USE_NMPR")))) {
					str = str.replaceAll("[$]\\{use_nmpr\\}", String.valueOf(lstCartPurchs.get(i).get("USE_NMPR")));
					str = str.replaceAll("[$]\\{use_nmpr_display\\}", "block");
				} else {
					str = str.replaceAll("[$]\\{use_nmpr\\}", "");
					str = str.replaceAll("[$]\\{use_nmpr_display\\}", "none");
				}
				if(lstCartPurchs.get(i).get("USE_PD") != null && !"".equals(String.valueOf(lstCartPurchs.get(i).get("USE_PD")))) {
					str = str.replaceAll("[$]\\{use_pd\\}", String.valueOf(lstCartPurchs.get(i).get("USE_PD")));
					str = str.replaceAll("[$]\\{use_pd_display\\}", "block");
				} else {
					str = str.replaceAll("[$]\\{use_pd\\}", "");
					str = str.replaceAll("[$]\\{use_pd_display\\}", "none");
				}
				orderlist += str;
			}		
		
		order = order.replaceAll("[$]\\{orderitem\\}", orderlist);
		
		int saleAmount = Integer.valueOf(String.valueOf(map.get("real_setle_amount"))) - Integer.valueOf(String.valueOf(map.get("tot_setle_amount")));
		order = order.replaceAll("[$]\\{tourist_nm\\}", String.valueOf(map.get("tourist_nm")));
		order = order.replaceAll("[$]\\{tourist_cttpc\\}", String.valueOf(map.get("tourist_cttpc")));
		order = order.replaceAll("[$]\\{kakao_id\\}", String.valueOf(map.get("kakao_id")));
		order = order.replaceAll("[$]\\{origin_amount\\}", String.format("%,d", Integer.valueOf(String.valueOf(map.get("real_setle_amount")))));
		order = order.replaceAll("[$]\\{sale_amount\\}", String.format("%,d", saleAmount));
		order = order.replaceAll("[$]\\{purchs_amount\\}", String.format("%,d", Integer.valueOf(String.valueOf(map.get("tot_setle_amount")))));
		order = order.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);
		order = order.replaceAll("[$]\\{purchs_sn\\}", String.valueOf(purchs_sn));		
		
		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
		content = content.replaceAll("[$]\\{title\\}", "결제내역입니다.");
		content = content.replaceAll("[$]\\{title2\\}", "");		
		content = content.replaceAll("[$]\\{contents\\}", order);
		
		//content = content.replaceAll("[$]\\{contents\\}", "일정표를 보려면 <a href='http://" + webserverip + "/purchs/OrderInfo?purchs_sn=" + purchs_sn + "' target='_blank'>[여기]</a>를 클릭하세요.");
		
		//map.put("email", "leeyikw@gmail.com");		
		if(map.get("email") != null && !"".equals(String.valueOf(map.get("email"))))
			mailManager.sendMail(subject, content, String.valueOf(map.get("email")), attachMap);
		
		return String.valueOf(purchs_sn);
	}

	public List<HashMap> getCartPurchsList(HashMap map) throws Exception {
		return orderDAO.getCartPurchsList(map);
	}
	
	public HashMap getPurchs(HashMap map) throws Exception {
		return orderDAO.getPurchs(map);
	}

	public HashMap getPay(HashMap map) throws Exception {
		return orderDAO.getPay(map);
	}

	public List<HashMap> getCancelCode(HashMap map) throws Exception {
		return orderDAO.getCancelCode(map);
	}
	
	public HashMap getCancelRefundAmount(HashMap map) throws Exception {
		return orderDAO.getCancelRefundAmount(map);
	}
	
	public void cancelPurchs(HashMap map) throws Exception {
		orderDAO.cancelPurchs(map);
		orderDAO.cancelReservationDay(map);
	}
	
	public void updateStatus(HashMap map) throws Exception {
		orderDAO.updateStatus(map);		
	}

}

