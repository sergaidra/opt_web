package kr.co.siione.gnrl.cart.web;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.utl.LoginManager;
import twitter4j.internal.org.json.JSONObject;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("cart_sn", cart_sn);

        model.addAttribute("result", result);
        model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);

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
    
    @RequestMapping(value="/updateAction/")
    public ResponseEntity<String> updateAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
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

    @RequestMapping(value="/deleteAction/")
    public void deleteAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String cart_sn = SimpleUtils.default_set(request.getParameter("hidCartSn"));
    
    	HashMap map = new HashMap();
    	map.put("cart_sn", cart_sn);
    	map.put("esntl_id", esntl_id);
       	cartService.deleteCart(map);

		response.sendRedirect("/cart/list/");
	}



    @RequestMapping(value="/schedulePopup/")
    public String scheduler(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/cart/schedule";
    }
}
