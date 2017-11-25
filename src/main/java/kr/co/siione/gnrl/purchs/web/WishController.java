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
import kr.co.siione.gnrl.purchs.service.WishService;
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
public class WishController {

	@Resource
    private WishService wishService;
	@Resource
    private PointService pointService;
	@Resource
    private CartService cartService;

	@RequestMapping(value="/Wish")
	public String Wish(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

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
       	model.addAttribute("btitle", "찜목록");
        model.addAttribute("mtitle", "포인트조회");
		
		return "gnrl/purchs/Wish";
	}

    @RequestMapping(value="/getWishList")
    public @ResponseBody Map<String, Object> getWishList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int pageSize = 5;
		int startIdx = (hidPage - 1) * pageSize + 1;
		int endIdx = hidPage * pageSize;

    	map.put("esntl_id", esntl_id);   
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	System.out.println("[getPointList]map:"+map);
		int totalCount = wishService.getWishListCount(map);
    	List<HashMap> list = wishService.getWishList(map);    	
    	for(int i = 0; i < list.size(); i++) {
    		HashMap nMap = new HashMap();
    		nMap.put("CART_SN", list.get(i).get("CART_SN"));
    		list.get(i).put("OPTIONS", cartService.selectCartDetailList(nMap));    		
    	}

    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("list", list);
    	mapResult.put("startIdx", startIdx);

    	return mapResult;
    }
}
