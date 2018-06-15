package kr.co.siione.gnrl.cs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import kr.co.siione.gnrl.cs.service.CheckListService;
import kr.co.siione.gnrl.cs.service.NoticeService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.mngr.service.StplatManageService;
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
@RequestMapping(value = "/cs/")
public class CheckListController {


	@Resource
	private CheckListService checklistService;
	@Resource
	private NoticeService noticeService;
	@Resource
	private BbsService bbsService;

	private static final Logger LOG = LoggerFactory.getLogger(LiveViewController.class);

	@RequestMapping(value="/checklist_oldold")
	public String checklist_oldold(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("bp", "04");
       	model.addAttribute("btitle", "세부알고가기");
       	model.addAttribute("mtitle", "");
        
		return "gnrl/cs/checklist_old";
	}

	@RequestMapping(value="/checklist_old")
	public String checklist_old(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap map = new HashMap();
		map.put("category", "C");			

		List<HashMap> lst = checklistService.getChecklist(map);
		
		if(lst.size() > 0) {
	        model.addAttribute("contents", lst.get(0).get("CONTENTS"));
		} else {
	        model.addAttribute("contents", "");
		}
		
        model.addAttribute("bp", "04");
       	model.addAttribute("btitle", "세부알고가기");
       	model.addAttribute("mtitle", "");
        
		return "gnrl/cs/checklist";
	}

	@RequestMapping(value="/checklistview")
	public String checklisteditor(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap map = new HashMap();
		map.put("category", "C");			
		List<HashMap> lst = checklistService.getChecklist(map);
		
		if(lst.size() > 0) {
	        model.addAttribute("contents", lst.get(0).get("CONTENTS"));
		} else {
	        model.addAttribute("contents", "");
		}
		
        model.addAttribute("bp", "04");
       	model.addAttribute("btitle", "세부알고가기");
       	model.addAttribute("mtitle", "");
        
		return "gnrl/cs/checklistview";
	}

	@RequestMapping(value="/saveChecklist_old")
	public @ResponseBody ResponseVo saveChecklist_old(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String category = "C";
			String contents = UserUtils.nvl(param.get("contents"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("contents", contents);	

			UserUtils.log("[saveChecklist-map]", map);
			
			checklistService.saveChecklist(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/checklist")
	public String checklist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
        model.addAttribute("category", "C");

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "세부알고가기");
        model.addAttribute("mtitle", "");
		
		return "gnrl/cs/notice";
	}

    @RequestMapping(value="/viewChecklist")
    public String viewNotice(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = noticeService.viewBbs(map);
			bbsService.updateBbsViewCnt(map);			
			model.addAttribute("view", view);		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("category", "C");
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "세부알고가기");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "view");

		return "gnrl/cs/checkistView";
	}

    @RequestMapping(value="/modifyChecklist")
    public String modifyChecklist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = noticeService.viewBbs(map);
			model.addAttribute("view", view);		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("category", "C");
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "세부알고가기");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "modify");

		return "gnrl/cs/checkistView";
	}

	@RequestMapping(value="/saveChecklist")
	public @ResponseBody ResponseVo saveChecklist(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String category = "C";
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));
			String subcategory = UserUtils.nvl(param.get("subcategory"));
			String popup_at = UserUtils.nvl(param.get("popup_at"));
			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	
			map.put("subcategory", subcategory);	
			map.put("popup_at", popup_at);	
			map.put("bbs_sn", bbs_sn);	

			UserUtils.log("[saveNotice-map]", map);
			
			if("".equals(bbs_sn)) {
				noticeService.insertBbs(map);
			} else {
				noticeService.updateBbs(map);
			}
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/writeChecklist")
	public String writeChecklist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
			String user_nm = UserUtils.nvl((String)session.getAttribute("user_nm"));
			String email = UserUtils.nvl((String)session.getAttribute("email"));
			
			SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd" );
			Date currentTime = new Date ();

			HashMap view = new HashMap();
			view.put("USER_NM", user_nm);
			view.put("EMAIL", email);
			view.put("WRITNG_DT", mSimpleDateFormat.format ( currentTime ));
			model.addAttribute("view", view);
		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("category", "C");
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "세부알고가기");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "write");

		return "gnrl/cs/checkistView";
	}

}