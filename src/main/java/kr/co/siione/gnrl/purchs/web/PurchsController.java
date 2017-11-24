package kr.co.siione.gnrl.purchs.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
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
	
	@RequestMapping(value="/OrderList")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {

			/*
			long payment = cartService.getCartPayment(map);			
			List<HashMap> cartList = cartService.getCartList(map);
			int list_cnt = 0;
			if(cartList.size() > 0)
				list_cnt = Integer.parseInt(cartList.get(0).get("TOT_CNT").toString());
			
			model.addAttribute("cartList", cartList);
			model.addAttribute("payCount", list_cnt);
			model.addAttribute("payment", payment);
			*/
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
			
			purchsService.addPurchs(map);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
}
