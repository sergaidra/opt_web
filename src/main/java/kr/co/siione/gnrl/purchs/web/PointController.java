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
public class PointController {

	@Resource
    private PointService pointService;

	@RequestMapping(value="/Point")
	public String Point(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

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
        model.addAttribute("mtitle", "포인트조회");
		
		return "gnrl/purchs/Point";
	}

    @RequestMapping(value="/getPointList")
    public @ResponseBody Map<String, Object> getPointList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int pageSize = 10;
		int startIdx = (hidPage - 1) * pageSize + 1;
		int endIdx = hidPage * pageSize;

    	map.put("esntl_id", esntl_id);   
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	System.out.println("[getPointList]map:"+map);
		int totalCount = pointService.getPointListCount(map);
    	List<HashMap> list = pointService.getPointList(map);    	

    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("list", list);
    	mapResult.put("startIdx", startIdx);

    	return mapResult;
    }
}
