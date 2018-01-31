package kr.co.siione.gnrl.purchs.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.gnrl.purchs.service.impl.OrderDAO;
import kr.co.siione.mngr.service.CtyManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import com.inicis.std.util.HttpUtil;
import com.inicis.std.util.ParseUtil;
import com.inicis.std.util.SignatureUtil;
import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

@Controller
@RequestMapping(value = "/purchs/")
@PropertySource("classpath:property/globals.properties")
public class OrderController {

	@Resource
    private OrderService orderService;
	@Resource
    private CartService cartService;
	@Resource
    private PointService pointService;
	
	@Value("#{globals['inicis.mid']}")
	private String inicis_mid;
	@Value("#{globals['inicis.signKey']}")
	private String inicis_signKey;
	@Value("#{globals['inicis.subdomain']}")
	private String inicis_subdomain;
	@Value("#{globals['inicis.mode']}")
	private String inicis_mode;	

	@RequestMapping(value="/Order")
	public String Order(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		System.out.println(request.getParameter("lstCart"));
		String strCart = UserUtils.nvl(request.getParameter("lstCart"));

		String[] arrCart = strCart.split(",");
		List<HashMap> lstCart = new ArrayList();
		try {
			for(int i = 0; i < arrCart.length; i++) {
				map.put("cart_sn", arrCart[i]);
				HashMap mapCart = orderService.getCartDetail(map);
				lstCart.add(mapCart);
			}

		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("lstCart", lstCart);
        model.addAttribute("cart_sn", strCart);

        model.addAttribute("mid", inicis_mid);
        model.addAttribute("oid", inicis_mid + "_" + com.inicis.std.util.SignatureUtil.getTimestamp());
        model.addAttribute("timestamp", com.inicis.std.util.SignatureUtil.getTimestamp());
        model.addAttribute("mKey", com.inicis.std.util.SignatureUtil.hash(inicis_signKey, "SHA-256"));
        model.addAttribute("user_nm", UserUtils.nvl((String)session.getAttribute("user_nm")));
        model.addAttribute("email", UserUtils.nvl((String)session.getAttribute("email")));
        model.addAttribute("inicis_subdomain", inicis_subdomain);
        model.addAttribute("inicis_mode", inicis_mode);
        
        model.addAttribute("point", pointService.getTotalPoint(map));
                
        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "세부정보입력/결제하기");
        model.addAttribute("mtitle", "결제하기");
		
		return "gnrl/purchs/Order";
	}	

	@RequestMapping(value="/close")
	public String close(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		
		return "gnrl/purchs/close";
	}	

	@RequestMapping(value="/getSignature")
	public @ResponseBody ResponseVo getSignature(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			String oid = UserUtils.nvl(param.get("oid"));
			String price = UserUtils.nvl(param.get("price"));
			String timestamp = UserUtils.nvl(param.get("timestamp"));
			
			Map<String, String> signParam = new HashMap<String, String>();

			signParam.put("oid",		oid); 							// 필수
			signParam.put("price", price);							// 필수
			signParam.put("timestamp",	timestamp);		// 필수

			// signature 데이터 생성 (모듈에서 자동으로 signParam을 알파벳 순으로 정렬후 NVP 방식으로 나열해 hash)
			String signature = com.inicis.std.util.SignatureUtil.makeSignature(signParam);

			resVo.setData(signature);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	private String eucToUtf(String value) {
		if(value == null || "".equals(value))
			return "";
		else
			try {
				return new String(value.getBytes("euc-kr"), "UTF-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return value;
			}
	}
	@RequestMapping(value="/payNext")
	public void payNext(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String email = UserUtils.nvl((String)session.getAttribute("email"));

		Map<String,String> paramMap = new Hashtable<String,String>();
		Enumeration elems = request.getParameterNames();
		String temp = "";
		while(elems.hasMoreElements())
		{
			temp = (String) elems.nextElement();
			paramMap.put(temp, request.getParameter(temp));
		} 
		
		System.out.println("paramMap : "+ paramMap.toString());
		
		if("01".equals(String.valueOf(paramMap.get("P_STATUS")))) {
			// 인증 실패
		} else {
			System.out.println("####인증성공/승인요청####");
			String p_req_url = String.valueOf(paramMap.get("P_REQ_URL"));
			String p_tid = String.valueOf(paramMap.get("P_TID"));
			String p_mid = inicis_mid;
			p_req_url = p_req_url + "?P_TID=" + p_tid + "&P_MID=" + p_mid;

		    // Create an instance of HttpClient.
		    HttpClient client = new HttpClient();

		    // Create a method instance.
		    GetMethod method = new GetMethod(p_req_url);
		    
		    // Provide custom retry handler is necessary
		    method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));
		    
		    HashMap<String, String> map = new HashMap<String, String>();
		    
		    try {
		      // Execute the method.
		      int statusCode = client.executeMethod(method);

		      if (statusCode != HttpStatus.SC_OK) {
		    	  System.out.println("Method failed: " + method.getStatusLine());
		      }

		      // Read the response body.
		      byte[] responseBody = method.getResponseBody();   //  승인결과 파싱
			  String[] values = new String(responseBody, "euc-kr").split("&");
			  
				for( int x = 0; x < values.length; x++ ) 
				  {
					System.out.println(values[x]);
					
					// 승인결과를 파싱값 잘라 hashmap에 저장
					int i = values[x].indexOf("=");			
					String key1 = values[x].substring(0, i);
					String value1 = values[x].substring(i+1);
					map.put(key1, value1);			  
				  }
				
				UserUtils.log("[payNext-map]", map);
				
				if("00".equals(map.get("P_STATUS"))) {
					HashMap mapPay = new HashMap();	
					HashMap mapPurchs = new HashMap();
					
		            JSONParser parser = new JSONParser();
		            JSONObject jsonObj = new JSONObject();
		            try { 
		            	//merchantData = merchantData.replaceAll("&quot", "\"");
		            	String p_noti = URLDecoder.decode(UserUtils.nvl(map.get("P_NOTI")), "UTF-8");
		            	jsonObj = (JSONObject)parser.parse(p_noti);
		            	List<Map> lstCart = (List<Map>)jsonObj.get("lstCart");
		            	
		    			mapPurchs.put("esntl_id", esntl_id);			
		            	mapPurchs.put("tot_setle_amount", UserUtils.nvl(jsonObj.get("tot_setle_amount")));
		            	mapPurchs.put("real_setle_amount", UserUtils.nvl(jsonObj.get("real_setle_amount")));
		            	mapPurchs.put("use_point", UserUtils.nvl(jsonObj.get("use_point")));
		            	mapPurchs.put("crtfc_no", "");
		            	mapPurchs.put("setle_ip", "");
		            	mapPurchs.put("tourist_nm", UserUtils.nvl(jsonObj.get("tourist_nm")));
		            	mapPurchs.put("tourist_cttpc", UserUtils.nvl(jsonObj.get("tourist_cttpc")));
		    			mapPurchs.put("kakao_id", UserUtils.nvl(jsonObj.get("kakao_id")));
		    			mapPurchs.put("lstCart", lstCart);
		    			mapPurchs.put("email", email);
						mapPurchs.put("status", "C");
		            } catch(ParseException e) {
		            	e.printStackTrace();
		            }
					
		            String appldate = String.valueOf(map.get("P_AUTH_DT")).substring(0, 8);
		            String appltime = String.valueOf(map.get("P_AUTH_DT")).substring(8);
		            
					mapPay.put("tid", map.get("P_TID"));
					mapPay.put("resultcode", map.get("P_STATUS"));
					mapPay.put("resultmsg", map.get("P_RMESG1"));
					mapPay.put("eventcode", "");
					mapPay.put("totprice", map.get("P_AMT"));
					mapPay.put("moid", map.get("P_OID"));
					mapPay.put("paymethod", "Card");
					mapPay.put("applnum", map.get("P_AUTH_NO"));
					mapPay.put("appldate", appldate);
					mapPay.put("appltime", appltime);
					mapPay.put("pay_device", "M");

					String CARD_Num = map.get("P_CARD_NUM");	// 카드번호
					String CARD_Interest = map.get("P_CARD_INTEREST");	// 할부여부
					String CARD_Quota = map.get("P_RMESG2");	// 할부기간
					String CARD_Code = map.get("P_FN_CD1");	// 카드 종류
					String CARD_BankCode = map.get("P_CARD_ISSUER_CODE");	// 카드 발급사
					mapPay.put("card_num", CARD_Num);
					mapPay.put("card_interest", CARD_Interest);
					mapPay.put("card_quota", CARD_Quota);
					mapPay.put("card_code", CARD_Code);
					mapPay.put("card_bankcode", CARD_BankCode);

					String purchs_sn = orderService.addPurchs(mapPurchs, mapPay);
					
					response.sendRedirect("/purchs/OrderDetail?purchs_sn=" + purchs_sn);
					return;					
				} else {
			    	System.out.println("승인 실패 : " + map.get("P_RMESG1"));
				}
		    } catch (HttpException e) {
		    	System.out.println("Fatal protocol violation: " + e.getMessage());
		    	e.printStackTrace();
		    } catch (IOException e) {
		    	System.out.println("Fatal transport error: " + e.getMessage());
		    	e.printStackTrace();
		    } finally {
		      // Release the connection.
		      method.releaseConnection();
		    }  
		}
	}
	
	@RequestMapping(value="/payComplete")
	public void payComplete(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String email = UserUtils.nvl((String)session.getAttribute("email"));
		
		Map<String,String> paramMap = new Hashtable<String,String>();
		Enumeration elems = request.getParameterNames();
		String temp = "";
		while(elems.hasMoreElements())
		{
			temp = (String) elems.nextElement();
			paramMap.put(temp, request.getParameter(temp));
		}
		
		System.out.println("paramMap : "+ paramMap.toString());
		
		//#####################
		// 인증이 성공일 경우만
		//#####################
		if("0000".equals(paramMap.get("resultCode"))){
			System.out.println("####인증성공/승인요청####");
			
			//############################################
			// 1.전문 필드 값 설정(***가맹점 개발수정***)
			//############################################
			String mid 		= paramMap.get("mid");					        // 가맹점 ID 수신 받은 데이터로 설정			
			String signKey	= inicis_signKey;	// 가맹점에 제공된 키(이니라이트키) (가맹점 수정후 고정) !!!절대!! 전문 데이터로 설정금지			
			String timestamp= SignatureUtil.getTimestamp();			  // util에 의해서 자동생성
			String charset 	= "UTF-8";								            // 리턴형식[UTF-8,EUC-KR](가맹점 수정후 고정)			
			String format 	= "JSON";								              // 리턴형식[XML,JSON,NVP](가맹점 수정후 고정)			
			String authToken= paramMap.get("authToken");			    // 취소 요청 tid에 따라서 유동적(가맹점 수정후 고정)
			String authUrl	= paramMap.get("authUrl");				    // 승인요청 API url(수신 받은 값으로 설정, 임의 세팅 금지)
			String netCancel= paramMap.get("netCancelUrl");			  // 망취소 API url(수신 받은 값으로 설정, 임의 세팅 금지)
			String ackUrl = paramMap.get("checkAckUrl");			    // 가맹점 내부 로직 처리후 최종 확인 API URL(수신 받은 값으로 설정, 임의 세팅 금지)
			String cardnum = paramMap.get("cardnum");				      //갤러리아 카드번호(카드끝자리 '*' 처리) 2016-01-12
			String merchantData = paramMap.get("merchantData");				      //원패스투어 결제정보
			
			HashMap mapPurchs = new HashMap();	
			mapPurchs.put("esntl_id", esntl_id);			
			
            JSONParser parser = new JSONParser();
            JSONObject jsonObj = new JSONObject();
            try { 
            	//merchantData = merchantData.replaceAll("&quot", "\"");
            	merchantData = URLDecoder.decode(UserUtils.nvl(merchantData), "UTF-8");
            	jsonObj = (JSONObject)parser.parse(merchantData);
            	List<Map> lstCart = (List<Map>)jsonObj.get("lstCart");
            	
            	mapPurchs.put("tot_setle_amount", UserUtils.nvl(jsonObj.get("tot_setle_amount")));
            	mapPurchs.put("real_setle_amount", UserUtils.nvl(jsonObj.get("real_setle_amount")));
            	mapPurchs.put("use_point", UserUtils.nvl(jsonObj.get("use_point")));
            	mapPurchs.put("crtfc_no", "");
            	mapPurchs.put("setle_ip", "");
            	mapPurchs.put("tourist_nm", UserUtils.nvl(jsonObj.get("tourist_nm")));
            	mapPurchs.put("tourist_cttpc", UserUtils.nvl(jsonObj.get("tourist_cttpc")));
    			mapPurchs.put("kakao_id", UserUtils.nvl(jsonObj.get("kakao_id")));
    			mapPurchs.put("lstCart", lstCart);
    			mapPurchs.put("email", email);
            } catch(ParseException e) {
            	e.printStackTrace();
            }

			//#####################
			// 2.signature 생성
			//#####################
			Map<String, String> signParam = new HashMap<String, String>();

			signParam.put("authToken",	authToken);		// 필수
			signParam.put("timestamp",	timestamp);		// 필수

			// signature 데이터 생성 (모듈에서 자동으로 signParam을 알파벳 순으로 정렬후 NVP 방식으로 나열해 hash)
			String signature = SignatureUtil.makeSignature(signParam);

			//#####################
			// 3.API 요청 전문 생성
			//#####################
			Map<String, String> authMap = new Hashtable<String, String>();

			authMap.put("mid"			    ,mid);			  // 필수
			authMap.put("authToken"		,authToken);	// 필수
			authMap.put("signature"		,signature);	// 필수
			authMap.put("timestamp"		,timestamp);	// 필수
			authMap.put("charset"		  ,charset);		// default=UTF-8
			authMap.put("format"		  ,format);		  // default=XML
      
			System.out.println("##승인요청 API 요청##");

			HttpUtil httpUtil = new HttpUtil();
			
			try{
				//#####################
				// 4.API 통신 시작
				//#####################

				String authResultString = "";

				authResultString = httpUtil.processHTTP(authMap, authUrl);
				
				//############################################################
				//5.API 통신결과 처리(***가맹점 개발수정***)
				//############################################################
				System.out.println("## 승인 API 결과 ##");
				
				String test = authResultString.replace(",", "&").replace(":", "=").replace("\"", "").replace(" ","").replace("\n", "").replace("}", "").replace("{", "");				
				Map<String, String> resultMap = new HashMap<String, String>();				
				resultMap = ParseUtil.parseStringToMap(test); //문자열을 MAP형식으로 파싱
								
				System.out.println("resultMap == " + resultMap);
				
				/*************************  결제보안 강화 2016-05-18 START ****************************/ 
				Map<String , String> secureMap = new HashMap<String, String>();
				secureMap.put("mid"			, mid);								//mid
				secureMap.put("tstamp"		, timestamp);						//timestemp
				secureMap.put("MOID"		, resultMap.get("MOID"));			//MOID
				secureMap.put("TotPrice"	, resultMap.get("TotPrice"));		//TotPrice
				
				// signature 데이터 생성 
				String secureSignature = SignatureUtil.makeSignatureAuth(secureMap);
				/*************************  결제보안 강화 2016-05-18 END ****************************/

				if("0000".equals(resultMap.get("resultCode")) && secureSignature.equals(resultMap.get("authSignature")) ){	//결제보안 강화 2016-05-18
				   /*****************************************************************************
			       * 여기에 가맹점 내부 DB에 결제 결과를 반영하는 관련 프로그램 코드를 구현한다.  
				   
					 [중요!] 승인내용에 이상이 없음을 확인한 뒤 가맹점 DB에 해당건이 정상처리 되었음을 반영함
							  처리중 에러 발생시 망취소를 한다.
			       ******************************************************************************/	
					HashMap mapPay = new HashMap();	
					
					//공통 부분만
					String tid = resultMap.get("tid"); // 거래번호
					String payMethod = resultMap.get("payMethod"); // 결제방법(지불수단)
					String TotPrice = resultMap.get("TotPrice"); // 결제완료금액
					String MOID = resultMap.get("MOID"); // 주문 번호
					String applDate = resultMap.get("applDate"); // 승인날짜
					String applTime = resultMap.get("applTime"); // 승인시간
					
					mapPay.put("tid", tid);
					mapPay.put("resultcode", resultMap.get("resultCode"));
					mapPay.put("resultmsg", resultMap.get("resultMsg"));
					mapPay.put("eventcode", resultMap.get("EventCode"));
					mapPay.put("totprice", TotPrice);
					mapPay.put("moid", MOID);
					mapPay.put("paymethod", payMethod);
					mapPay.put("applnum", resultMap.get("applNum"));
					mapPay.put("appldate", applDate);
					mapPay.put("appltime", applTime);

					if("VBank".equals(resultMap.get("payMethod"))){ //가상계좌
						String VACT_Num = resultMap.get("VACT_Num");	// 입금 계좌번호
						String VACT_BankCode = resultMap.get("VACT_BankCode");	// 입금 은행코드
						String vactBankName = resultMap.get("vactBankName");	// 입금 은행명
						String VACT_Name = resultMap.get("VACT_Name");	// 예금주 명
						String VACT_InputName = resultMap.get("VACT_InputName");	// 송금자 명
						String VACT_Date = resultMap.get("VACT_Date");	// 송금 일자
						String VACT_Time = resultMap.get("VACT_Time");	// 송금 시간
						mapPay.put("vact_num", VACT_Num);
						mapPay.put("vact_bankcode", VACT_BankCode);
						mapPay.put("vactbankname", vactBankName);
						mapPay.put("vact_name", VACT_Name);
						mapPay.put("vact_inputname", VACT_InputName);
						mapPay.put("vact_date", VACT_Date);
						mapPay.put("vact_time", VACT_Time);
						mapPurchs.put("status", "W");
					} else if("DirectBank".equals(resultMap.get("payMethod"))){ //실시간계좌이체
						String ACCT_BankCode = resultMap.get("ACCT_BankCode");	// 은행코드
						String CSHR_ResultCode = resultMap.get("CSHR_ResultCode");	// 현금영수증 발급결과코드
						String CSHR_Type = resultMap.get("CSHR_Type");	// 현금영수증 발급구분코드
						mapPay.put("acct_bankcode", ACCT_BankCode);
						mapPay.put("cshr_resultcode", CSHR_ResultCode);
						mapPay.put("cshr_type", CSHR_Type);
						mapPurchs.put("status", "C");
					} else{//카드
						String CARD_Num = resultMap.get("CARD_Num");	// 카드번호
						String CARD_Interest = resultMap.get("CARD_Interest");	// 할부여부
						String CARD_Quota = resultMap.get("CARD_Quota");	// 할부기간
						String CARD_Code = resultMap.get("CARD_Code");	// 카드 종류
						String CARD_BankCode = resultMap.get("CARD_BankCode");	// 카드 발급사
						mapPay.put("card_num", CARD_Num);
						mapPay.put("card_interest", CARD_Interest);
						mapPay.put("card_quota", CARD_Quota);
						mapPay.put("card_code", CARD_Code);
						mapPay.put("card_bankcode", CARD_BankCode);
						mapPurchs.put("status", "C");
				    }	

					mapPay.put("pay_device", "P");		// PC

					String purchs_sn = orderService.addPurchs(mapPurchs, mapPay);
					
					response.sendRedirect("/purchs/OrderDetail?purchs_sn=" + purchs_sn);
					return;
				} else {
					//결제보안키가 다른 경우
					if (!secureSignature.equals(resultMap.get("authSignature"))) {
						//결과정보
						System.out.println("* 데이터 위변조 체크 실패");
						
						//망취소
						if ("0000".equals(resultMap.get("resultCode"))) {
							throw new Exception("데이터 위변조 체크 실패");
						}
					}
				}
			} catch (Exception ex) {

				//####################################
				// 실패시 처리(***가맹점 개발수정***)
				//####################################

				//---- db 저장 실패시 등 예외처리----//
				System.out.println(ex);

				//#####################
				// 망취소 API
				//#####################
				String netcancelResultString = httpUtil.processHTTP(authMap, netCancel);	// 망취소 요청 API url(고정, 임의 세팅 금지)

				System.out.println("## 망취소 API 결과 ##");

				// 취소 결과 확인
				System.out.println(netcancelResultString);
			}
		} else {
			System.out.println("####인증실패####");
		}
		response.sendRedirect("/purchs/OrderDetail");
	}	
	
	@RequestMapping(value="/addAction")
	public @ResponseBody ResponseVo addAction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			String email = UserUtils.nvl((String)session.getAttribute("email"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String tot_setle_amount = UserUtils.nvl(param.get("tot_setle_amount"));
			String real_setle_amount = UserUtils.nvl(param.get("real_setle_amount"));
			String use_point = UserUtils.nvl(param.get("use_point"));
			String tourist_nm = UserUtils.nvl(param.get("tourist_nm"));
			String tourist_cttpc = UserUtils.nvl(param.get("tourist_cttpc"));
			String kakao_id = UserUtils.nvl(param.get("kakao_id"));
			String crtfc_no = "";
			String setle_ip = "";
			List<Map> lstCart = (List<Map>)param.get("lstCart");

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
			map.put("status", "C");

			UserUtils.log("[addPurchs-map]", map);
			
			String purchs_sn = orderService.addPurchs(map, null);
			resVo.setResult("0");	
			resVo.setData(purchs_sn);
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/VBankInput")
	@ResponseBody
	public String VBankInput(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String,String> paramMap = new Hashtable<String,String>();
		Enumeration elems = request.getParameterNames();
		String temp = "";
		while(elems.hasMoreElements())
		{
			temp = (String) elems.nextElement();
			paramMap.put(temp, request.getParameter(temp));
		}
		UserUtils.log("[VBankInput paramMap]", paramMap);

		try {
			HashMap map = new HashMap();
			map.put("status", "C");
			map.put("oid", String.valueOf(paramMap.get("no_oid")));
			orderService.updateStatus(map);
			return "OK";
		} catch(Exception e) {
			return e.getMessage();
		}
	}
	
	
	
	@RequestMapping(value="/checkReservationSchedule")
	public @ResponseBody ResponseVo checkReservationSchedule(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			List<Map> lstCart = (List<Map>)param.get("lstCart");

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("lstCart", lstCart);

			UserUtils.log("[checkReservationSchedule-map]", map);

			Boolean isOk = true;
			for(int i = 0; i < lstCart.size(); i++) {
				// 스케줄 체크
				if(orderService.chkSchedule((HashMap)lstCart.get(i)) > 0) {
					resVo.setResult("2");			
					resVo.setMessage("해당 날짜에 이미 예약되었습니다.");
					isOk = false;
				}
			}
						
			if(isOk == true) {
				resVo.setResult("0");			
			}
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/checkReservationScheduleFlight")
	public @ResponseBody ResponseVo checkReservationScheduleFlight(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			List<Map> lstCart = (List<Map>)param.get("lstCart");

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("lstCart", lstCart);

			UserUtils.log("[checkReservationScheduleFlight-map]", map);

			Boolean isOk = true;
			for(int i = 0; i < lstCart.size(); i++) {
				// 스케줄 체크
				if(orderService.chkSchedule((HashMap)lstCart.get(i)) > 0) {
					resVo.setResult("2");			
					resVo.setMessage("해당 날짜에 이미 예약되었습니다.");
					isOk = false;
				}
			}
			
			// 항공편 정보
			for(int i = 0; i < lstCart.size(); i++) {
				// 항공편 체크
				if(orderService.chkFlight((HashMap)lstCart.get(i)) > 0) {
					resVo.setResult("3");			
					resVo.setMessage("항공정보를 입력해주세요.");
					isOk = false;
				}
			}
			
			if(isOk == true) {
				resVo.setResult("0");			
			}
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/setFlightCart")
	public @ResponseBody ResponseVo setFlightCart(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			String flight_sn = String.valueOf(param.get("flight_sn"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}


			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("flight_sn", flight_sn);

			UserUtils.log("[setFlightCart-map]", map);
			
			orderService.setFlight(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/OrderDetail")
	public String OrderDetail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		System.out.println(request.getParameter("purchs_sn"));
		String purchs_sn = UserUtils.nvl(request.getParameter("purchs_sn"));
		map.put("purchs_sn", purchs_sn);

		HashMap purchs = orderService.getPurchs(map);
		HashMap pay = orderService.getPay(map);
		if(purchs.get("TOURIST_CTTPC") != null && !"".equals(purchs.get("TOURIST_CTTPC"))) {
			String [] arrCttPc = String.valueOf(purchs.get("TOURIST_CTTPC")).split("\\-");
			if(arrCttPc.length == 3) {
				purchs.put("TOURIST_CTTPC1", arrCttPc[0]);
				purchs.put("TOURIST_CTTPC2", arrCttPc[1]);
				purchs.put("TOURIST_CTTPC3", arrCttPc[2]);
			}
		}
		List<HashMap> lstCartPurchs = orderService.getCartPurchsList(map);
		
		List<HashMap> lstCart = new ArrayList();
		try {
			for(int i = 0; i < lstCartPurchs.size(); i++) {
				map.put("cart_sn", lstCartPurchs.get(i).get("CART_SN"));
				HashMap mapCart = orderService.getCartDetail(map);
				mapCart.put("PICKUP_PLACE", lstCartPurchs.get(i).get("PICKUP_PLACE"));
				mapCart.put("DROP_PLACE", lstCartPurchs.get(i).get("DROP_PLACE"));
				mapCart.put("USE_NMPR", lstCartPurchs.get(i).get("USE_NMPR"));
				mapCart.put("USE_PD", lstCartPurchs.get(i).get("USE_PD"));
				
				lstCart.add(mapCart);
			}

		} catch(Exception e) {e.printStackTrace();}		

        model.addAttribute("lstCart", lstCart);
        model.addAttribute("purchs_sn", purchs_sn);
        model.addAttribute("purchs", purchs);
        model.addAttribute("pay", pay);        

        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "결제 상세보기");
        model.addAttribute("mtitle", "상세보기");
		
		return "gnrl/purchs/Order";
	}	
	
    @RequestMapping(value="/popupCancel")
    public String popupFlight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
      	HashMap map = new HashMap();

		String purchs_sn = UserUtils.nvl(request.getParameter("purchs_sn"));
		String callback = UserUtils.nvl(request.getParameter("callback"));		

    	map.put("purchs_sn", purchs_sn);   
    	System.out.println("[popupCancel]map:"+map);
    	
    	List<HashMap> lstCancelCode = orderService.getCancelCode(map);
    	
    	model.addAttribute("lstCancelCode", lstCancelCode);
    	model.addAttribute("purchs_sn", purchs_sn);
    	model.addAttribute("callback", callback);
    	
		return "gnrl/popup/cancel";	
    }	
	
    @RequestMapping(value="/cancelPurchs")
    public @ResponseBody ResponseVo cancelPurchs(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
	    	HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}
			
	      	HashMap map = new HashMap();

			String purchs_sn = UserUtils.nvl(param.get("purchs_sn"));
			String delete_resn_se = UserUtils.nvl(param.get("delete_resn_se"));
			String delete_resn_etc = UserUtils.nvl(param.get("delete_resn_etc"));
			String refund_amount = UserUtils.nvl(param.get("refund_amount"));

	    	map.put("purchs_sn", purchs_sn);   
	    	map.put("delete_resn_se", delete_resn_se);
	    	map.put("delete_resn_etc", delete_resn_etc);
	    	map.put("esntl_id", esntl_id);
	    	System.out.println("[cancelPurchs]map:"+map);
	    	
	    	HashMap mapAmount = orderService.getCancelRefundAmount(map);
	    	map.put("refund_amount", String.valueOf(mapAmount.get("REFUND_AMOUNT")));
	    	
	    	orderService.cancelPurchs(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	    	
    }
}
