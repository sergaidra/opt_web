package kr.co.siione.gnrl.bbs.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.bbs.service.BbsService;
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
@RequestMapping(value = "/bbs/")
public class BbsController {

	@Resource
	private BbsService bbsService;

	private static final Logger LOG = LoggerFactory.getLogger(BbsController.class);

	@RequestMapping(value="/list")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {

		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("category", "R");

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행예약");
        model.addAttribute("mtitle", "");
		
		return "gnrl/bbs/bbslist";
	}

    @RequestMapping(value="/getBbsList")
    public @ResponseBody Map<String, Object> getBbsList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		String category = UserUtils.nvl(param.get("category"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 10 + 1;
		int endIdx = hidPage * 10;

    	map.put("esntl_id", esntl_id);   
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	map.put("category", category);
    	System.out.println("[getBbsList]map:"+map);
		int totalCount = bbsService.selectBbsListCount(map);
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("startIdx", String.valueOf(startIdx));
    	List<HashMap> list = bbsService.selectBbsList(map);    	
    	mapResult.put("list", list);

    	return mapResult;
    }
	@RequestMapping(value="/write")
	public String write(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {

		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행예약");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "write");

		return "gnrl/bbs/bbsview";
	}

	@RequestMapping(value="/writeaction")
	public @ResponseBody ResponseVo writeaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String category = UserUtils.nvl(param.get("category"));
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	

			UserUtils.log("[writeaction-map]", map);
			
			bbsService.insertBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/view")
	public String view(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = bbsService.viewBbs(map);
			bbsService.updateBbsViewCnt(map);
			model.addAttribute("view", view);
		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행예약");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "view");

		return "gnrl/bbs/bbsview";
	}
	
	@RequestMapping(value="/deleteaction")
	public @ResponseBody ResponseVo deleteaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("bbs_sn", bbs_sn);			

			UserUtils.log("[deleteaction-map]", map);
			
			bbsService.deleteBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/modify")
	public String modify(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = bbsService.viewBbs(map);
			model.addAttribute("view", view);
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행예약");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "modify");

		return "gnrl/bbs/bbsview";
	}

	@RequestMapping(value="/modifyaction")
	public @ResponseBody ResponseVo modifyaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String category = UserUtils.nvl(param.get("category"));
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));
			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	
			map.put("bbs_sn", bbs_sn);	

			UserUtils.log("[writeaction-map]", map);
			
			bbsService.updateBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

}