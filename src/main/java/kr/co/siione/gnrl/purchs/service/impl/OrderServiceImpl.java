package kr.co.siione.gnrl.purchs.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import com.inicis.inipay.INIpay50;

import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("OrderService")
@PropertySource("classpath:property/globals.properties")
public class OrderServiceImpl implements OrderService {

	@Resource(name = "orderDAO")
	private OrderDAO orderDAO;
	
	@Resource
    private	MailManager mailManager;
	
	@Resource
    private PointService pointService;
	
	@Resource
	private CommonService commonService;

	
	@Value("#{globals['server.ip']}")
	private String webserverip;
	@Value("#{globals['server.domain']}")
	private String webserverdomain;
	@Value("#{globals['inicis.mid']}")
	private String inicis_mid;
	@Value("#{globals['inicis.signKey']}")
	private String inicis_signKey;
	@Value("#{globals['inicis.subdomain']}")
	private String inicis_subdomain;
	@Value("#{globals['inicis.mode']}")
	private String inicis_mode;	

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
				if(mapCart.get("GOODS_OPTION") != null)
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
		order = order.replaceAll("[$]\\{deposit_amount\\}", String.format("%,d", Integer.valueOf(String.valueOf(map.get("deposit_amount")))));
		order = order.replaceAll("[$]\\{remain_amount\\}", String.format("%,d", Integer.valueOf(String.valueOf(map.get("remain_amount")))));
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

	public List<HashMap> getCode(HashMap map) throws Exception {
		return orderDAO.getCode(map);
	}
	
	public HashMap getCancelRefundAmount(HashMap map) throws Exception {
		return orderDAO.getCancelRefundAmount(map);
	}
	
	public void cancelPurchs(HashMap map) throws Exception {
		map.put("status", "R");		// 환불완료
		int refund_amount = Integer.valueOf(String.valueOf(map.get("refund_amount")));		
		int real_setle_amount = Integer.valueOf(String.valueOf(map.get("real_setle_amount")));	
		//refund_amount = 50;
		//real_setle_amount = 150;

		Boolean isVBankPast = false;
		Boolean isVBank = false;
		HashMap hm = orderDAO.getPay(map);

		if(map.containsKey("VBankPast") && "Y".equals(String.valueOf(map.get("VBankPast")))) {
			// 무통장입금 기한 만료
			isVBankPast = true;
		} 
		if(hm != null && "VBank".equals(hm.get("PAYMETHOD"))) {
			// 무통장입금 
			isVBank = true;
		} 
		
		if(refund_amount > 0 && isVBankPast == false && isVBank == true) {
			map.put("status", "P");		// 환불요청
		}
		
		orderDAO.cancelPurchs(map);
		orderDAO.cancelReservationDay(map);
		pointService.cancelPoint(map);
		
		if(isVBankPast == true) {
			// 무통장입금 기한 만료
			return;
		} 
		
		if(isVBank == true) {
			// 무통장입금
			return;
		} 		

		if(refund_amount > 0) {
			if(hm != null) {
				// 이니시스 부분 취소
				INIpay50 inipay = new INIpay50();	

				/***********************
				 * 3. 재승인 정보 설정 *
				 ***********************/
				inipay.SetField("inipayhome", map.get("inicis_path") );				   // 이니페이 홈디렉터리(상점수정 필요)
				inipay.SetField("type"         , "repay");							   // 고정 (절대 수정 불가)
				inipay.SetField("debug"        , "true");								   // 로그모드("true"로 설정하면 상세로그가 생성됨.)
				inipay.SetField("admin"        , "1111");								   // 비대칭 사용키 키패스워드    
				//inipay.SetField("admin"        , inicis_signKey);								   // 비대칭 사용키 키패스워드    
				inipay.SetField("mid"          , inicis_mid);		   // 상점아이디
				inipay.SetField("oldtid"       , UserUtils.nvl(hm.get("TID")));		   // 취소할 거래의 거래아이디
				inipay.SetField("currency"     , "WON");	   // 화폐단위
				inipay.SetField("price"        , String.valueOf(refund_amount));         // 취소금액
				inipay.SetField("confirm_price", String.valueOf(real_setle_amount - refund_amount)); // 승인요청금액
				inipay.SetField("buyeremail"   , map.get("email"));    // 구매자 이메일 주소

				inipay.SetField("no_acct"      , "");       // 국민은행 부분취소 환불계좌번호
				inipay.SetField("nm_acct"      , "");       // 국민은행 부분취소 환불계좌주명

				inipay.SetField("tax"			 , "");		    // 부가세
				inipay.SetField("tax_free"     , "");       // 비과세

				// ExecureCrypto_v1.0_jdk14.jar 모듈이 설치 되어 있어 있지 않은 상태라면
				// 익스트러스 암복호화 모듈 설정을 주석 처리 해주시기 바랍니다.
				inipay.SetField("crypto","execure");//익스트러스 암복호화 모듈 설정

				/******************
				 * 4. 재승인 요청 *
				 ******************/
				inipay.startAction();
				
				if("00".equals(inipay.GetResult("ResultCode"))) {
					// 성공
				} else { 
					// 실패
					String msg = inipay.GetResult("ResultMsg");
					System.out.println("실패 메시지 : " + msg);
					new Exception(msg);
				}
			}			
		}

	}
	
	public void updateStatus(HashMap map) throws Exception {
		orderDAO.updateStatus(map);		
	}
	
	public HashMap getPayPre(HashMap map) throws Exception {
		return orderDAO.getPayPre(map);		
	}
	
	public void updateNoti(HashMap mapPurchs, HashMap mapPay) throws Exception {
		int cnt = orderDAO.getPayMoid(mapPay);
		if(cnt > 0) {
			orderDAO.updateStatus(mapPurchs);		
			orderDAO.updatePay(mapPay);		
		} else {
			mapPay.put("status", mapPurchs.get("status"));
			orderDAO.deletePayPre(mapPay);
			orderDAO.insertPayPre(mapPay);
		}
	}	

	public HashMap getPurchInfoSession(HttpSession session) {
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String email = UserUtils.nvl((String)session.getAttribute("email"));
		HashMap purchInfo = (HashMap)session.getAttribute("purchInfo");
		
		String tot_setle_amount = UserUtils.nvl(purchInfo.get("tot_setle_amount"));
		String real_setle_amount = UserUtils.nvl(purchInfo.get("real_setle_amount"));
		String use_point = UserUtils.nvl(purchInfo.get("use_point"));
		String tourist_nm = UserUtils.nvl(purchInfo.get("tourist_nm"));
		String tourist_cttpc = UserUtils.nvl(purchInfo.get("tourist_cttpc"));
		String kakao_id = UserUtils.nvl(purchInfo.get("kakao_id"));
		String crtfc_no = "";
		String setle_ip = "";
		String deposit_amount = UserUtils.nvl(purchInfo.get("deposit_amount"));
		String remain_amount = UserUtils.nvl(purchInfo.get("remain_amount"));
		String exchange_rate = UserUtils.nvl(purchInfo.get("exchange_rate"));
        List<Map> lstCart = (List<Map>)purchInfo.get("lstCart");

		HashMap map = new HashMap();	
		map.put("esntl_id", esntl_id);			
		map.put("tot_setle_amount", tot_setle_amount);
		map.put("real_setle_amount", real_setle_amount);
		map.put("use_point", use_point);
		map.put("crtfc_no", crtfc_no);
		map.put("setle_ip", setle_ip);
		map.put("tourist_nm", tourist_nm);
		map.put("tourist_cttpc", tourist_cttpc);
		map.put("kakao_id", kakao_id);
		map.put("lstCart", lstCart);
		map.put("email", email);
		map.put("deposit_amount", deposit_amount);
		map.put("remain_amount", remain_amount);
		map.put("exchange_rate", exchange_rate);

		return map;
	}
	
	public List<HashMap> getPastVBank(HashMap map) throws Exception {
		return orderDAO.getPastVBank(map);
	}
	
	public HashMap getReservationStatus(HashMap map) throws Exception {
		return orderDAO.getReservationStatus(map);
	}

	public void updateReservationStatus(HashMap map) throws Exception {
		orderDAO.updateReservationStatus(map);

		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());
		
		HashMap mapCart = getCartDetail(map);

		String subject = "원패스투어 예약 확인 요청드립니다.";
		String title = "예약 확인 요청드립니다.";
		String file_code = String.valueOf(mapCart.get("FILE_CODE"));
		String goods_nm = String.valueOf(mapCart.get("GOODS_NM"));
		String date = String.valueOf(mapCart.get("GOODS_DATE"));
		String options = String.valueOf(mapCart.get("GOODS_TIME"));		
		String item_amount = String.format("%,d", Integer.valueOf(String.valueOf(mapCart.get("ORIGIN_AMOUNT"))));

		if(!"".equals(options))
			options += "<br/>";
		options += String.valueOf(mapCart.get("GOODS_OPTION"));

    	List<HashMap> lstManager = commonService.getManagerUser(map);
    	for(int i = 0;i < lstManager.size(); i++)
    		commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount, String.valueOf(map.get("email")));
    	
    	commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount,"onepasstour@gmail.com");
    	//commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount,"leeyikw@gmail.com");
	}
	
	public Double getExchangeRate(HashMap map) throws Exception {
		return orderDAO.getExchangeRate(map);
	}
}

