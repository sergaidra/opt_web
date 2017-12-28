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
public class OrderController {

	@Resource
    private OrderService orderService;
	@Resource
    private CartService cartService;
	@Resource
    private PointService pointService;
	
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

        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "세부정보입력/결제하기");
        model.addAttribute("mtitle", "결제하기");
		
		return "gnrl/purchs/Order";
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

			UserUtils.log("[addPurchs-map]", map);

			Boolean isOk = true;
			for(int i = 0; i < lstCart.size(); i++) {
				// 스케줄 체크
				HashMap map2 = new HashMap();
				map2.put("can_yn", ""); 
				map2.put("cart_sn", lstCart.get(i).get("cart_sn"));
				orderService.chkSchedule(map2);
				
				if("N".equals(String.valueOf(map2.get("can_yn")).trim())) {
					resVo.setResult("2");			
					resVo.setMessage("해당 날짜에 이미 예약되었습니다.");
					isOk = false;
				}
			}
			
			if(isOk == true) {
				orderService.addPurchs(map);
				resVo.setResult("0");			
			}
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
				HashMap map2 = new HashMap();
				map2.put("can_yn", ""); 
				map2.put("cart_sn", lstCart.get(i).get("cart_sn"));
				orderService.chkSchedule(map2);
				
				if("N".equals(String.valueOf(map2.get("can_yn")).trim())) {
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
}
