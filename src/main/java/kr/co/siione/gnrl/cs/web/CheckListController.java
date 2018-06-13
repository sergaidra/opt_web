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
	
	private static final Logger LOG = LoggerFactory.getLogger(LiveViewController.class);

	@RequestMapping(value="/checklist_old")
	public String checklist_old(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("bp", "04");
       	model.addAttribute("btitle", "세부알고가기");
       	model.addAttribute("mtitle", "");
        
		return "gnrl/cs/checklist_old";
	}

	@RequestMapping(value="/checklist")
	public String checklist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
	
}