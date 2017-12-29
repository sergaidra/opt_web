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
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.utl.MailManager;

@Service("OrderService")
@PropertySource("classpath:property/globals.properties")
public class OrderServiceImpl implements OrderService {

	@Resource(name = "orderDAO")
	private OrderDAO orderDAO;
	
	@Resource
    private	MailManager mailManager;
	
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
	
	private String getMailHtml() {
		StringBuilder builder = new StringBuilder();
		org.springframework.core.io.Resource resource = new ClassPathResource("html/mail.htm"); 
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

	public void addPurchs(HashMap map) throws Exception {
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
		
		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());
		String subject = "원패스투어 결제내역입니다.";
		String content = getMailHtml();
		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
		content = content.replaceAll("[$]\\{title\\}", "결제내역입니다.");
		content = content.replaceAll("[$]\\{title2\\}", "");
		content = content.replaceAll("[$]\\{contents\\}", "일정표를 보려면 <a href='http://" + webserverip + "/purchs/OrderInfo?purchs_sn=" + purchs_sn + "' target='_blank'>[여기]</a>를 클릭하세요.");
		
		//map.put("email", "leeyikw@gmail.com");		
		mailManager.sendMail(subject, content, String.valueOf(map.get("email")), attachMap);
	}

}

