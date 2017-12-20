package kr.co.siione.gnrl.purchs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
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

			String tot_setle_amount = UserUtils.nvl(param.get("tot_setle_amount"));
			String real_setle_amount = UserUtils.nvl(param.get("real_setle_amount"));
			String use_point = UserUtils.nvl(param.get("use_point"));
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
			map.put("lstCart", lstCart);

			UserUtils.log("[addPurchs-map]", map);

			Boolean isOk = true;
			for(int i = 0; i < lstCart.size(); i++) {
				// 스케줄 체크
				HashMap map2 = new HashMap();
				map2.put("can_yn", ""); 
				map2.put("cart_sn", lstCart.get(i).get("cart_sn"));
				purchsService.chkSchedule(map2);
				
				if("N".equals(String.valueOf(map2.get("can_yn")).trim())) {
					resVo.setResult("2");			
					resVo.setMessage("해당 날짜에 이미 예약되었습니다.");
					isOk = false;
				}
			}
			
			if(isOk == true) {
				purchsService.addPurchs(map);
				resVo.setResult("0");			
			}
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
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
			String cart_sn = UserUtils.nvl(param.get("cart_sn"));

	    	map.put("purchs_sn", purchs_sn);   
	    	map.put("cart_sn", cart_sn);
	    	map.put("esntl_id", esntl_id);
	    	System.out.println("[cancelPurchs]map:"+map);
	    	
	    	purchsService.cancelPurchs(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	    	
    }

}
