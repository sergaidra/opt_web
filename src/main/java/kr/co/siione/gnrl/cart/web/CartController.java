package kr.co.siione.gnrl.cart.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cart.service.FlightService2;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/cart/")
public class CartController {

	@Resource
	private GoodsService goodsService;

	@Resource
	private CartService cartService;
	
	@Resource
	private FlightService2 flightService;

	@Resource
	private ArprtManageService arprtManageService;

	private static final Logger LOG = LoggerFactory.getLogger(CartController.class);

	@RequestMapping(value="/list")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {

			//long payment = cartService.getCartPayment(map);			
			List<HashMap> cartList = cartService.getCartList(map);
			//int list_cnt = 0;
			//if(cartList.size() > 0)
			//	list_cnt = Integer.parseInt(cartList.get(0).get("TOT_CNT").toString());
			
			model.addAttribute("cartList", cartList);
			//model.addAttribute("payCount", list_cnt);
			//model.addAttribute("payment", payment);
		
		} catch(Exception e) {e.printStackTrace();}

		model.addAttribute("cart_list_yn", "Y");
		
        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "마이페이지");
        model.addAttribute("mtitle", "예약목록(장바구니)");
		
		return "gnrl/cart/list";
	}
	
	@RequestMapping(value="/delAction")
	public @ResponseBody ResponseVo delAction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		HttpSession session = request.getSession();
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");
		
		try {
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			List<String> cart_sn = (List<String>)param.get("cart_sn");
	
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}
			
			List<HashMap> lstMap = new ArrayList();
			
			for(int i = 0; i < cart_sn.size(); i++) {
				HashMap map = new HashMap();
				map.put("cart_sn", cart_sn.get(i));
				map.put("esntl_id", esntl_id);
				lstMap.add(map);
			}
			
			cartService.deleteCart(lstMap);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	/**
	 * 장바구니 : 숙박시설과 다른 상품을 한 목록으로 페이징한 화면 (임시)
	 */
	@RequestMapping(value="/cart_list_page/")
	public String cart_list_page(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		//현재 페이지 파라메타
		String hidPage = UserUtils.nvl(request.getParameter("hidPage"));
		int intPage = 1;
		if(!hidPage.equals(""))
			intPage = Integer.parseInt((String)hidPage);

		//페이지 기본설정
		int pageBlock = 6;
		int pageArea = 10;


		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		long payment = cartService.getCartPayment(map);

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());

		int list_cnt = 0;
		List<HashMap> list = cartService.getCartList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			paginationInfo.setTotalRecordCount(list_cnt);
		}

		model.addAttribute("paginationInfo", paginationInfo);
		model.addAttribute("hidPage", hidPage);
		model.addAttribute("list", list);

		model.addAttribute("payCount", list_cnt);
		model.addAttribute("payment", payment);

		return "gnrl/cart/cart_list_page";
	}
	
	/**
	 * 장바구니 : 디자인 적용 전 백업 (임시)
	 */
	@RequestMapping(value="/list_b_cart/")
	public String list_b_cart(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
		
		long payment = cartService.getCartPayment(map);

		int list_cnt = 0;

		map.put("SEARCH_SE", "A");
		List<HashMap> actList = cartService.getCartListBySearchSe(map);
		if(actList.size() > 0){
			list_cnt += Integer.parseInt(actList.get(0).get("TOT_CNT").toString());
		}
		
		map.put("SEARCH_SE", "S");
		List<HashMap> stayngList = cartService.getCartListBySearchSe(map);
		if(stayngList.size() > 0){
			list_cnt += Integer.parseInt(stayngList.get(0).get("TOT_CNT").toString());
		}
		
		model.addAttribute("actList", actList);
		model.addAttribute("stayngList", stayngList);
		
		model.addAttribute("payCount", list_cnt);
		model.addAttribute("payment", payment);
		
		} catch(Exception e) {e.printStackTrace();}

		model.addAttribute("cart_list_yn", "Y");
		return "gnrl/cart/list_b_cart";
	}
	
	@RequestMapping(value="/list2/")
	public String list2(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
		/*
		int list_cnt = 0;
		
		map.put("SEARCH_SE", "A");
		List<HashMap> actList = cartService.getCartListBySearchSe(map);
		if(actList.size() > 0){
			list_cnt += Integer.parseInt(actList.get(0).get("TOT_CNT").toString());
		}
		
		map.put("SEARCH_SE", "S");
		List<HashMap> stayngList = cartService.getCartListBySearchSe(map);
		if(stayngList.size() > 0){
			list_cnt += Integer.parseInt(stayngList.get(0).get("TOT_CNT").toString());
		}
		
		model.addAttribute("actList", actList);
		model.addAttribute("stayngList", stayngList);
		*/

		long payment = cartService.getCartPayment(map);			
		List<HashMap> cartList = cartService.getCartList(map);
		int list_cnt = Integer.parseInt(cartList.get(0).get("TOT_CNT").toString());
		
		model.addAttribute("cartList", cartList);
		model.addAttribute("payCount", list_cnt);
		model.addAttribute("payment", payment);
		
		} catch(Exception e) {e.printStackTrace();}

		model.addAttribute("cart_list_yn", "Y");
		return "gnrl/cart/list_old";
	}

	@RequestMapping(value="/detail/")
	public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String cart_sn = UserUtils.nvl(request.getParameter("hidCartSn"));
		String hidPage = UserUtils.nvl(request.getParameter("hidPage"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		map.put("cart_sn", cart_sn);
		HashMap result = cartService.getCartDetail(map);

		String goods_code = (String) result.get("GOODS_CODE");

		map.put("goods_code", goods_code);
		List<HashMap> nmprList = cartService.getCartNmprList(map);
		//List<HashMap> clList = goodsService.getGoodsClList(map);
		List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
		List<HashMap> timeList = goodsService.getGoodsTimeList(map);

		/*String stayngFcltyAt = "N";
		for(HashMap clMap : clList) {
			if(UserUtils.nvl(clMap.get("STAYNG_FCLTY_AT")).equals("Y")) {
				stayngFcltyAt = "Y";
				break;
			}
		}
		model.addAttribute("stayngFcltyAt", stayngFcltyAt);*/

		model.addAttribute("hidPage", hidPage);
		model.addAttribute("cart_sn", cart_sn);

		model.addAttribute("result", result);
		//model.addAttribute("clList", clList);
		model.addAttribute("schdulList", schdulList);
		model.addAttribute("nmprList", nmprList);
		model.addAttribute("timeList", timeList);

		return "gnrl/cart/detail";
	}

	@RequestMapping(value="/addAction")
	public @ResponseBody ResponseVo addAction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String goods_code = UserUtils.nvl(param.get("hidGoodsCode"));
			String purchs_amount = UserUtils.nvl(param.get("PURCHS_AMOUNT"));
			String origin_amount = UserUtils.nvl(param.get("ORIGIN_AMOUNT"));
			String flight_sn = UserUtils.nvl(param.get("flight_sn"));
			
			// 일반상품
			String tour_de = UserUtils.nvl(param.get("TOUR_DE")).replaceAll("-", "");
			String tour_time = UserUtils.nvl(param.get("TOUR_TIME"));
			
			// 숙박
			String chkin_de = UserUtils.nvl(param.get("CHKIN_DE")).replaceAll("-", "");
			String chckt_de = UserUtils.nvl(param.get("CHCKT_DE")).replaceAll("-", "");
			
			String begin_time = "";
			String end_time = "";
			
			if(tour_time.length() == 8) {
				begin_time = tour_time.substring(0, 4);
				end_time = tour_time.substring(4, 8);
			}
			
			List<Map> nmprList = (List<Map>)param.get("nmprList");

			HashMap map = new HashMap();
			map.put("opert_se", "I");			
			map.put("esntl_id", esntl_id);			
			map.put("goods_code", goods_code);
			map.put("purchs_amount", purchs_amount);
			map.put("origin_amount", origin_amount);			
			map.put("tour_de", tour_de);
			map.put("chkin_de", chkin_de);
			map.put("chckt_de", chckt_de);
			map.put("nmpr_list", nmprList);
			map.put("begin_time", begin_time);
			map.put("flight_sn", flight_sn);
			map.put("end_time", end_time);

			UserUtils.log("[addCard-map]", map);
			
			cartService.addCart(map);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/addAction2/")
	public ResponseEntity<String> addAction2(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();
		UserUtils.log("[addCart-param]", param);

		try { 
		
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";
		String retMessage = "";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			String goods_code = UserUtils.nvl(param.get("hidGoodsCode"));
			String purchs_amount = UserUtils.nvl(param.get("PURCHS_AMOUNT").replaceAll(",", "").replaceAll("₩", ""));
			
			// 일반상품
			String tour_de = UserUtils.nvl(param.get("TOUR_DE")).replaceAll("-", "");
			String tour_time = UserUtils.nvl(param.get("TOUR_TIME"));
			
			// 숙박
			String chkin_de = UserUtils.nvl(param.get("CHKIN_DE")).replaceAll("-", "");
			String chckt_de = UserUtils.nvl(param.get("CHCKT_DE")).replaceAll("-", "");
			
			String[] arrSetupSe = request.getParameterValues("SETUP_SE");
			String[] arrNmprSn = request.getParameterValues("NMPR_SN");
			String[] arrCartNmprCo = request.getParameterValues("CART_NMPR_CO");
			
			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< arrSetupSe.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("setup_se", arrSetupSe[i]);
				nmap.put("nmpr_sn", arrNmprSn[i]);
				nmap.put("nmpr_co", arrCartNmprCo[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(arrCartNmprCo[i]) && Integer.parseInt(arrCartNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}
			

			/*String hidStayngFcltyAt = UserUtils.nvl(param.get("hidStayngFcltyAt"), "N");
			String hidChkinDe = UserUtils.nvl(param.get("hidChkinDe"));
			String hidChcktDe = UserUtils.nvl(param.get("hidChcktDe"));

			String hidWaitTime = UserUtils.nvl(param.get("hidWaitTime"));
			String hidMvmnTime = UserUtils.nvl(param.get("hidMvmnTime"));

			String[] hidNmprCo = request.getParameterValues("hidNmprCo");
			String[] hidNmprSn = request.getParameterValues("hidNmprSn");

			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< hidNmprCo.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("nmpr_co", hidNmprCo[i]);
				nmap.put("nmpr_sn", hidNmprSn[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(hidNmprCo[i]) && Integer.parseInt(hidNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}*/

			HashMap map = new HashMap();
			map.put("opert_se", "I");			
			map.put("esntl_id", esntl_id);			
			map.put("goods_code", goods_code);
			map.put("purchs_amount", purchs_amount);
			map.put("tour_de", tour_de);
			map.put("chkin_de", chkin_de);
			map.put("chckt_de", chckt_de);
			map.put("nmpr_list", nmprList);
			if(tour_time.length() == 8) {
				map.put("begin_time", tour_time.substring(0, 4));
				map.put("end_time", tour_time.substring(4, 8));
			} else {
				map.put("begin_time", "");
				map.put("end_time", "");
			}

			UserUtils.log("[addCard-map]", map);
			
			cartService.addCart(map);
			retValue = "0";
		}
		
		LOG.debug("[addCard]retValue:"+retValue);
		LOG.debug("[addCard]retMessage:"+retMessage);
		obj.put("result", retValue);
		obj.put("message", retMessage);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		} catch(Exception e) {e.printStackTrace();}
		
		return entity;
	}

	@RequestMapping(value="/modAction/")
	public ResponseEntity<String> modAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";
		String retMessage = "";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		UserUtils.log("[modCard]param:", param);

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			String cart_sn = UserUtils.nvl(request.getParameter("hidCartSn"));
			String goods_code = UserUtils.nvl(request.getParameter("hidGoodsCode"));
			String tour_de = UserUtils.nvl(request.getParameter("TOUR_DE"));
			String hidTime = UserUtils.nvl(request.getParameter("TOUR_TIME"));

			String hidChkinDe = UserUtils.nvl(request.getParameter("CHKIN_DE"));
			String hidChcktDe = UserUtils.nvl(request.getParameter("CHCKT_DE"));

			String hidWaitTime = UserUtils.nvl(request.getParameter("hidWaitTime"));
			String hidMvmnTime = UserUtils.nvl(request.getParameter("hidMvmnTime"));

			String[] selNmprCo = request.getParameterValues("selNmprCo");
			String[] hidNmprSn = request.getParameterValues("hidNmprSn");

			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< selNmprCo.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("nmpr_co", selNmprCo[i]);
				nmap.put("nmpr_sn", hidNmprSn[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(selNmprCo[i]) && Integer.parseInt(selNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}

			HashMap map = new HashMap();
			map.put("opert_se", "U");
			map.put("cart_sn", cart_sn);
			map.put("goods_code", goods_code);
			map.put("nmpr_list", nmprList);
			map.put("tour_de", tour_de.replace("-",""));
			map.put("chkin_de", hidChkinDe.replace("-",""));
			map.put("chckt_de", hidChcktDe.replace("-",""));
			map.put("esntl_id", esntl_id);
			if(hidTime.length() == 8) {
				map.put("begin_time", hidTime.substring(0, 4));
				map.put("end_time", hidTime.substring(4, 8));
			} else {
				map.put("begin_time", "");
				map.put("end_time", "");
			}

			cartService.updateCart(map);
			retValue = "0";
			
		}

		LOG.debug("[modCard]retValue:"+retValue);
		LOG.debug("[modCard]retMessage:"+retMessage);
		obj.put("result", retValue);
		obj.put("message", retMessage);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}
	


	@RequestMapping(value="/getAction/")
	public ResponseEntity<String> getAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			HashMap map = new HashMap();
			map.put("esntl_id", esntl_id);

			List<HashMap> cartList = cartService.getCartListForSchedule(map);
			obj.put("cartList", cartList);

			retValue = "0";
		}

		obj.put("result", retValue);
		
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	// 일정표를 calender 형식으로 보여 줌.
	@RequestMapping(value="/calendarPopup/")
	public String calendar(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "gnrl/cart/calendar";
	}

	@RequestMapping(value="/bannerAction/")
	public String banner(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "gnrl/cart/banner";
	}

	@RequestMapping(value="/schedulePopup/")
	public String schedule(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		HashMap flight = flightService.getFlightDetail(map);
		List<HashMap> cartList = cartService.getCartListForSchedule(map);

		model.addAttribute("flight", flight);
		model.addAttribute("cartList", cartList);

		return "gnrl/cart/schedule";
	}	
}