package kr.co.siione.gnrl.purchs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.cmmn.service.FlightService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.gnrl.purchs.service.PointService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
import kr.co.siione.mngr.service.CtyManageService;
import kr.co.siione.utl.UserUtils;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/purchs/")
public class PurchsController {

	@Resource
    private PurchsService purchsService;
	@Resource
    private CartService cartService;
	@Resource
    private PointService pointService;
	@Resource
	private FlightService flightService;
	@Resource
    private GoodsService goodsService;
	@Resource
	private FileService fileService;

	@RequestMapping(value="/OrderList")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
			int point = pointService.getTotalPoint(map);
			model.addAttribute("point", point);

		} catch(Exception e) {e.printStackTrace();}
		
        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "마이페이지");
        model.addAttribute("mtitle", "결제목록");
		
		return "gnrl/purchs/OrderList";
	}
	
    @RequestMapping(value="/getPurchsList")
    public @ResponseBody Map<String, Object> getPurchsList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		String start_dt = UserUtils.nvl(param.get("start_dt"));
		String end_dt = UserUtils.nvl(param.get("end_dt"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 5 + 1;
		int endIdx = hidPage * 5;

    	map.put("esntl_id", esntl_id);   
    	map.put("start_dt", start_dt);
    	map.put("end_dt", end_dt);
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	map.put("delete_at", "N");
    	System.out.println("[결제목록]map:"+map);
		int totalCount = purchsService.getPurchsListCount(map);
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	List<HashMap> list = purchsService.getPurchsList(map);    	
    	for(int i = 0; i < list.size(); i++) {
    		HashMap nMap = new HashMap();
    		nMap.put("purchs_sn", list.get(i).get("PURCHS_SN"));    				
    		List<HashMap> lstCart = purchsService.getPurchsCartList(nMap);
    		for(int j = 0; j < lstCart.size(); j++) {
        		nMap.put("CART_SN", lstCart.get(j).get("CART_SN"));
        		lstCart.get(j).put("OPTIONS", cartService.selectCartDetailList(nMap));    		
    		}
    		list.get(i).put("cartlist", lstCart);
    	}
    	
    	mapResult.put("list", list);

    	return mapResult;
    }

	@RequestMapping(value="/OrderInfo")
	public String OrderInfo(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String purchs_sn = request.getParameter("purchs_sn");
		String cart_sn = request.getParameter("cart_sn");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		map.put("purchs_sn", purchs_sn);
		map.put("cart_sn", cart_sn);

    	List<HashMap> lstGoods = null;
    	
    	if(purchs_sn != null && !"".equals(purchs_sn)) {
    		lstGoods = purchsService.getOrderInfoGoodsTime(map);
    		HashMap purchs = purchsService.viewPurchs(map);
    		model.addAttribute("purchs", purchs);
    	}
    	else
    		lstGoods = purchsService.getCartInfoGoodsTime(map);

    	List<HashMap> lstFlight = new ArrayList();
    	List<String> lstFlightSn = new ArrayList();

    	SimpleDateFormat format = new SimpleDateFormat("yyyymmdd"); 
    	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-mm-dd"); 

    	LinkedHashMap<String, Object> mapDate = new LinkedHashMap<String, Object>();
    	
    	for(int i = 0; i < lstGoods.size(); i++) {
    		String strDt = "";
    		String strDt2 = "";
    		String time = "";
    		String text = "";
    		String options = "";
    		if("S".equals(String.valueOf(lstGoods.get(i).get("CL_SE"))) || "T".equals(String.valueOf(lstGoods.get(i).get("CL_SE")))) {
    			// 숙박
    			try	{
    				Date dt1 = format.parse(String.valueOf(lstGoods.get(i).get("CHKIN_DE")));
    				Date dt2 = format.parse(String.valueOf(lstGoods.get(i).get("CHCKT_DE")));
    				strDt = format.format(dt1);
    				strDt2 = format.format(dt2);
    			} catch(Exception ex) {
    				strDt = "";
    				strDt2 = "";
    			}
       			text = String.valueOf(lstGoods.get(i).get("GOODS_NM"));
       			options = String.valueOf(lstGoods.get(i).get("OPTIONS"));
    		} else {
    			try	{
    				Date dt1 = format.parse(String.valueOf(lstGoods.get(i).get("TOUR_DE")));
    				strDt = format.format(dt1);	    			
    			} catch(Exception ex) {
    				strDt = "";
    			}
       			String BEGIN_TIME = String.valueOf(lstGoods.get(i).get("BEGIN_TIME"));
       			String END_TIME = String.valueOf(lstGoods.get(i).get("END_TIME"));
       			time = BEGIN_TIME.substring(0, 2) + ":" + BEGIN_TIME.substring(2, 4) + " ~ " + END_TIME.substring(0, 2) + ":" + END_TIME.substring(2, 4);
       			text = String.valueOf(lstGoods.get(i).get("GOODS_NM"));
       			options = String.valueOf(lstGoods.get(i).get("OPTIONS"));
    		}
   			
          	HashMap mapGoods = new HashMap();
        	map.put("goods_code", String.valueOf(lstGoods.get(i).get("GOODS_CODE")));
        	map.put("esntl_id", esntl_id);
        	HashMap result = goodsService.getGoodsDetail(map);

        	if(result != null) {
            	List<Map<String, String>> lstVoucher = new ArrayList();
            	List<Map<String, String>> lstOpGuide = new ArrayList();
            	List<Map<String, String>> lstEtcInfo = new ArrayList();

            	map.put("file_code", result.get("FILE_CODE"));
            	map.put("hotdeal_at", "N");
            	map.put("recomend_at", "N");
            	map.put("liveview_at", "N");
            	List<HashMap> lstFile = fileService.getFileList(map);

            	// 바우처
            	if(!isEmpty(result, "VOCHR_TICKET_TY")) {
            		Map<String, String> m = new HashMap<String, String>();
            		m.put("text", "티켓형태");
            		String ty = String.valueOf(result.get("VOCHR_TICKET_TY"));
            		if("V".equals(ty))
            			m.put("value", "E-바우처");
            		else if("T".equals(ty))
            			m.put("value", "E-티켓(캡쳐가능)");
            		else if("E".equals(ty))
            			m.put("value", "확정메일(캡쳐가능)");
            		
            		lstVoucher.add(m);
            	}
            	addList(result, "VOCHR_NTSS_REQRE_TIME", lstVoucher, "발권소요시간");
            	addList(result, "VOCHR_USE_MTH", lstVoucher, "사용 방법");
            	addList(result, "GUIDANCE_USE_TIME", lstOpGuide, "이용시간");
            	addList(result, "GUIDANCE_REQRE_TIME", lstOpGuide, "소요시간");
            	addList(result, "GUIDANCE_AGE_DIV", lstOpGuide, "연령구분");
            	addList(result, "GUIDANCE_TOUR_SCHDUL", lstOpGuide, "여행일정");
            	addList(result, "GUIDANCE_PRFPLC_LC", lstOpGuide, "공연장위치");
            	addList(result, "GUIDANCE_EDC_CRSE", lstOpGuide, "교육과정");
            	addList(result, "GUIDANCE_OPTN_MATTER", lstOpGuide, "옵션사항");
            	addList(result, "GUIDANCE_PICKUP", lstOpGuide, "픽업");
            	addList(result, "GUIDANCE_PRPARETG", lstOpGuide, "준비물");
            	addList(result, "GUIDANCE_INCLS_MATTER", lstOpGuide, "포함사항");
            	addList(result, "GUIDANCE_NOT_INCLS_MATTER", lstOpGuide, "불포함사항");
            	addList(result, "ADIT_GUIDANCE", lstEtcInfo, "추가안내");
            	addList(result, "ATENT_MATTER", lstEtcInfo, "유의사항");
            	addList(result, "CHANGE_REFND_REGLTN", lstEtcInfo, "변경/환불규정"); 	
            	
            	result.put("lstVoucher", lstVoucher);
            	result.put("lstOpGuide", lstOpGuide);
            	result.put("lstEtcInfo", lstEtcInfo);
            	result.put("lstFile", lstFile);        	        		
        	}
        	
   			addMySchedule(mapDate, strDt, strDt2, time, text, options, result, lstGoods.get(i));
   			
   			// 항공정보
   			if(lstGoods.get(i).get("FLIGHT_SN") != null) {
   				String flight_sn = String.valueOf(lstGoods.get(i).get("FLIGHT_SN"));
   				if(!lstFlightSn.contains(flight_sn)) {
   	   				HashMap mFlight = new HashMap();
   	   				mFlight.put("flight_sn", flight_sn);
   	   				HashMap mapFlight = flightService.getFlight(mFlight);
   	   				if(mapFlight != null)
   	   					lstFlight.add(mapFlight);
   	   				lstFlightSn.add(flight_sn);
   				}
   			}
    	}	
    	
    	List<Map> lstReservation = new ArrayList();
    	String[] weekNm = new String[] { "일", "월", "화", "수", "목", "금", "토" };
    	
    	for (Map.Entry<String,Object> entry : mapDate.entrySet()) {
    		String strDt = entry.getKey().replace("S", "");
    		try {
        		Date dt1 = format.parse(strDt);
        		Calendar cal = Calendar.getInstance();
        		cal.setTime(dt1);
        		int dayNum = cal.get(Calendar.DAY_OF_WEEK);
        		
        		strDt = format2.format(dt1) + "(" + weekNm[dayNum - 1] + ")";
    		} catch(Exception ex) {
    			
    		}
    		List lstItem = (List)entry.getValue();
    		Map<String, Object> m = new HashMap<String, Object>();
    		m.put("day", strDt);
    		for(int i = 0; i < lstItem.size(); i++) {
    			LinkedHashMap<String, Object> itemMap = (LinkedHashMap<String, Object>)lstItem.get(i);
    			if(itemMap.get("chckt_de") != null && !"".equals(String.valueOf(itemMap.get("chckt_de")))) {
        			String strDt2 = String.valueOf(itemMap.get("chckt_de"));
            		try {
                		Date dt1 = format.parse(strDt2);
                		Calendar cal = Calendar.getInstance();
                		cal.setTime(dt1);
                		int dayNum = cal.get(Calendar.DAY_OF_WEEK);
                		
                		itemMap.put("chckt_de", format2.format(dt1) + "(" + weekNm[dayNum - 1] + ")");
            		} catch(Exception ex) {
            			
            		}
    			}
    		}
    		m.put("list", lstItem);
    		lstReservation.add(m);
    	}

    	
    	model.addAttribute("lstReservation", lstReservation);
   		model.addAttribute("lstFlight", lstFlight);
		
		return "gnrl/purchs/OrderInfo";
	}

    private void addMySchedule(LinkedHashMap<String, Object> mapDate, String dt, String dt2, String time, String text, String options, HashMap goods, HashMap purchs) {
    	List lst = null;
    	if(dt2 != null && !"".equals(dt2)) {
        	if(!mapDate.containsKey(dt + "S"))
        		mapDate.put(dt + "S", new ArrayList());
        	lst = (List)mapDate.get(dt + "S");
    	} else {
        	if(!mapDate.containsKey(dt))
        		mapDate.put(dt, new ArrayList());
        	lst = (List)mapDate.get(dt);
    	}
    	LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
   		map.put("chckt_de", dt2);
    	map.put("time", time);
    	map.put("text", text);
    	map.put("options", options);
    	map.put("goods", goods);
    	map.put("purchs", purchs);    	
    	lst.add(map);
    }

    private boolean isEmpty(Map map, String key) {
    	if(!map.containsKey(key) || map.get(key) == null || "".equals(String.valueOf(map.get(key)).trim()))
    		return true;
    	else
    		return false;
    }

    private void addList(Map map, String key, List<Map<String, String>> lst, String text) {
    	if(!isEmpty(map, key)) {
    		Map<String, String> m = new HashMap<String, String>();
    		m.put("text", text);
    		m.put("value", String.valueOf(map.get(key)));
    		lst.add(m);
    	}
    }

}
