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
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.utl.UserUtils;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import twitter4j.internal.org.json.JSONObject;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/cart/")
public class CartController {

	@Resource
    private GoodsService goodsService;

	@Resource
    private CartService cartService;

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
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

        return "gnrl/cart/list";
    }


    @RequestMapping(value="/detail/")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String cart_sn = SimpleUtils.default_set(request.getParameter("hidCartSn"));
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));

    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
    	map.put("cart_sn", cart_sn);
    	HashMap result = cartService.getCartDetail(map);
    	
    	String goods_code = (String) result.get("GOODS_CODE");
    	
    	map.put("goods_code", goods_code);
    	List<HashMap> nmprList = cartService.getCartNmprList(map);
    	List<HashMap> clList = goodsService.getGoodsClList(map);
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> timeList = goodsService.getGoodsTimeList(map);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("cart_sn", cart_sn);

        model.addAttribute("result", result);
        model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);
        model.addAttribute("timeList", timeList);

        return "gnrl/cart/detail";
    }

    @RequestMapping(value="/addAction/")
    public ResponseEntity<String> addAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
    	if(esntl_id.isEmpty()){
    		retValue = "-2";    		
    	}else{
            String goods_code = SimpleUtils.default_set(request.getParameter("hidGoodsCode"));
            String txtDate = SimpleUtils.default_set(request.getParameter("txtDate"));
            String   hidTime = SimpleUtils.default_set(request.getParameter("hidTime"));

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
        	map.put("goods_code", goods_code);
        	map.put("nmpr_list", nmprList);
        	map.put("tour_de", txtDate.replace("-",""));
        	map.put("esntl_id", esntl_id);
        	if(hidTime.length() == 8) {
	        	map.put("begin_time", hidTime.substring(0, 4));
	        	map.put("end_time", hidTime.substring(4, 8));
        	} else {
        		map.put("begin_time", "");
	        	map.put("end_time", "");
        	}

        	//상품조건이 맞는지 확인
        	HashMap result = cartService.getCartValidCnfirm(map);
        	if(result != null){
            	cartService.addCart(map);
    			retValue = "0";	
        	}    		
    	}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
    }
    
    @RequestMapping(value="/modAction/")
    public ResponseEntity<String> modAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));

    	if(esntl_id.isEmpty()){
    		retValue = "-2";    		
    	}else{
            String cart_sn = SimpleUtils.default_set(request.getParameter("hidCartSn"));
            String goods_code = SimpleUtils.default_set(request.getParameter("hidGoodsCode"));
            String txtDate = SimpleUtils.default_set(request.getParameter("txtDate"));
            String hidTime = SimpleUtils.default_set(request.getParameter("hidTime"));        

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
        	map.put("cart_sn", cart_sn);
        	map.put("goods_code", goods_code);
        	map.put("nmpr_list", nmprList);
        	map.put("tour_de", txtDate.replace("-",""));
        	map.put("esntl_id", esntl_id);
        	if(hidTime.length() == 8) {
	        	map.put("begin_time", hidTime.substring(0, 4));
	        	map.put("end_time", hidTime.substring(4, 8));
        	} else {
        		map.put("begin_time", "");
	        	map.put("end_time", "");
        	}

        	//상품조건이 맞는지 확인
        	HashMap result = cartService.getCartValidCnfirm(map);
        	if(result != null){
            	cartService.updateCart(map);
    			retValue = "0";	
        	}    		
    	}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
	}

    @RequestMapping(value="/delAction/")
    public void delAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String cart_sn = SimpleUtils.default_set(request.getParameter("hidCartSn"));
    
    	HashMap map = new HashMap();
    	map.put("cart_sn", cart_sn);
    	map.put("esntl_id", esntl_id);
       	cartService.deleteCart(map);

		response.sendRedirect("/cart/list/");
	}

    @RequestMapping(value="/getAction/")
    public ResponseEntity<String> getAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
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
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
    	
    	HashMap flight = cartService.getFlightDetail(map);
    	List<HashMap> cartList = cartService.getCartListForSchedule(map);
    	
    	model.addAttribute("flight", flight);
    	model.addAttribute("cartList", cartList);
    	
        return "gnrl/cart/schedule";
    }    
    
    @RequestMapping(value="/flightPopup/")
    public String flight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
    	
    	if(esntl_id.isEmpty()){
    		retValue = "-2";   
    	} else {
    		map = cartService.getFlightDetail(map);
    	}
    	
    	model.addAttribute("flight", map);
   	
        return "gnrl/cart/flight";
    }    
    
    
    @RequestMapping(value="/addFlightAction/")
    public ResponseEntity<String> addFlightAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
    	if(esntl_id.isEmpty()){
    		retValue = "-2";    		
    	}else{
    		HashMap<String, String> map = new HashMap();
    		map.put("esntl_id", esntl_id);
    		map.put("dtrmc_flight", UserUtils.nvl(param.get("DTRMC_FLIGHT")));
    		map.put("dtrmc_start_cty", UserUtils.nvl(param.get("DTRMC_START_CTY")));    		
    		map.put("dtrmc_start_dt", UserUtils.nvl(param.get("DTRMC_START_DE")).replace("-", "")+UserUtils.nvl(param.get("DTRMC_START_HH"))+UserUtils.nvl(param.get("DTRMC_START_MI")));
    		map.put("dtrmc_arvl_cty", UserUtils.nvl(param.get("DTRMC_ARVL_CTY")));    		
    		map.put("dtrmc_arvl_dt", UserUtils.nvl(param.get("DTRMC_ARVL_DE")).replace("-", "")+UserUtils.nvl(param.get("DTRMC_ARVL_HH"))+UserUtils.nvl(param.get("DTRMC_ARVL_MI")));
    		map.put("hmcmg_flight", UserUtils.nvl(param.get("HMCMG_FLIGHT")));
    		map.put("hmcmg_start_cty", UserUtils.nvl(param.get("HMCMG_START_CTY")));    		
    		map.put("hmcmg_start_dt", UserUtils.nvl(param.get("HMCMG_START_DE")).replace("-", "")+UserUtils.nvl(param.get("HMCMG_START_HH"))+UserUtils.nvl(param.get("HMCMG_START_MI")));
    		map.put("hmcmg_arvl_cty", UserUtils.nvl(param.get("HMCMG_ARVL_CTY")));    		
    		map.put("hmcmg_arvl_dt", UserUtils.nvl(param.get("HMCMG_ARVL_DE")).replace("-", "")+UserUtils.nvl(param.get("HMCMG_ARVL_HH"))+UserUtils.nvl(param.get("HMCMG_ARVL_MI")));	
  		
    		cartService.addFlight(map);
			retValue = "0";
    	}
	    	
		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
    }
    
    @RequestMapping(value="/modFlightAction/")
    public ResponseEntity<String> modFlightAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	String flight_sn = param.get("hidFlightSn").toString();

    	if(esntl_id.isEmpty()){
    		retValue = "-2";  
    	}else if(flight_sn.equals("") || flight_sn == null){
    		retValue = "-1";
    	}else{
    		HashMap<String, String> map = new HashMap();
    		map.put("esntl_id", esntl_id);
    		map.put("flight_sn", flight_sn);
    		map.put("dtrmc_flight", UserUtils.nvl(param.get("DTRMC_FLIGHT")));
    		map.put("dtrmc_start_cty", UserUtils.nvl(param.get("DTRMC_START_CTY")));    		
    		map.put("dtrmc_start_dt", UserUtils.nvl(param.get("DTRMC_START_DE")).replace("-", "")+UserUtils.nvl(param.get("DTRMC_START_HH"))+UserUtils.nvl(param.get("DTRMC_START_MI")));
    		map.put("dtrmc_arvl_cty", UserUtils.nvl(param.get("DTRMC_ARVL_CTY")));    		
    		map.put("dtrmc_arvl_dt", UserUtils.nvl(param.get("DTRMC_ARVL_DE")).replace("-", "")+UserUtils.nvl(param.get("DTRMC_ARVL_HH"))+UserUtils.nvl(param.get("DTRMC_ARVL_MI")));
    		map.put("hmcmg_flight", UserUtils.nvl(param.get("HMCMG_FLIGHT")));
    		map.put("hmcmg_start_cty", UserUtils.nvl(param.get("HMCMG_START_CTY")));    		
    		map.put("hmcmg_start_dt", UserUtils.nvl(param.get("HMCMG_START_DE")).replace("-", "")+UserUtils.nvl(param.get("HMCMG_START_HH"))+UserUtils.nvl(param.get("HMCMG_START_MI")));
    		map.put("hmcmg_arvl_cty", UserUtils.nvl(param.get("HMCMG_ARVL_CTY")));    		
    		map.put("hmcmg_arvl_dt", UserUtils.nvl(param.get("HMCMG_ARVL_DE")).replace("-", "")+UserUtils.nvl(param.get("HMCMG_ARVL_HH"))+UserUtils.nvl(param.get("HMCMG_ARVL_MI")));	
  		
    		cartService.updateFlight(map);
		
    
			retValue = "0";	
    	}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
	}      
    
    @RequestMapping(value="/getFlightAction/")
    public ResponseEntity<String> getFilightAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

    	HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");
		
		String retValue = "-1";
    	
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
    	
    	if(esntl_id.isEmpty()){
    		retValue = "-2";    		
    	}else{
        	HashMap map = new HashMap();
        	map.put("esntl_id", esntl_id);
        	
        	map = cartService.getFlightDetail(map);
        	obj.put("flight", map);
        	
        	retValue = "0";
    	}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);
		
    	return entity;
    }          
}
