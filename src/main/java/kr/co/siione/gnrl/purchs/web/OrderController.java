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
        
        int point = pointService.getTotalPoint(map);
        int maxpoint = point - (point % 1000);
        model.addAttribute("point", point);
        model.addAttribute("maxpoint", maxpoint);
                
        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "세부정보입력/결제하기");
        model.addAttribute("mtitle", "결제하기");
		
		return "gnrl/purchs/Order";
	}	
	
	@RequestMapping(value="/purchInfoStore")
	public @ResponseBody ResponseVo purchInfoStore(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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
			
			session.setAttribute("purchInfo", param);

			resVo.setResult("0");	
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;		
	}	
	
	@RequestMapping(value="/addAction")
	public @ResponseBody ResponseVo addAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
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
			
			HashMap map = orderService.getPurchInfoSession(session); 
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
