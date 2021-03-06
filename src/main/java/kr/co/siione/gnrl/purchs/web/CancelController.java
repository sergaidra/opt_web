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
import kr.co.siione.gnrl.purchs.service.CancelService;
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
public class CancelController {

	@Resource
    private PurchsService purchsService;
	@Resource
    private CartService cartService;
	@Resource
    private PointService pointService;
	@Resource
    private CancelService cancelService;

	@RequestMapping(value="/Cancel")
	public String Cancel(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

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
        model.addAttribute("mtitle", "취소목록");
		
		return "gnrl/purchs/Cancel";
	}

    @RequestMapping(value="/getCancelList")
    public @ResponseBody Map<String, Object> getCancelList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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
    	map.put("delete_at", "Y");
    	System.out.println("[getCancelList]map:"+map);
		int totalCount = cancelService.getCancelListCount(map);
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	List<HashMap> list = cancelService.getCancelList(map);  
    	
    	for(int i = 0; i < list.size(); i++) {
    		HashMap nMap = new HashMap();
    		nMap.put("purchs_sn", list.get(i).get("PURCHS_SN"));    				
    		List<HashMap> lstCart = cancelService.getPurchsCartList(nMap);
    		for(int j = 0; j < lstCart.size(); j++) {
        		nMap.put("CART_SN", lstCart.get(j).get("CART_SN"));
        		lstCart.get(j).put("OPTIONS", cartService.selectCartDetailList(nMap));    		
    		}
    		list.get(i).put("cartlist", lstCart);
    	}
    	mapResult.put("list", list);

    	return mapResult;
    }
}
