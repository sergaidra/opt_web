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
public class UseTextController {

	@Resource
	private BbsService bbsService;

	@Resource
	private StplatManageService stplatManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(LiveViewController.class);

	@RequestMapping(value="/usetext")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "고객지원");
       	model.addAttribute("mtitle", "이용약관");
        
		Map<String, String> param = new HashMap<String, String>();
		Map<String, String> result = new HashMap<String, String>();
		
		param.put("STPLAT_CODE", "000001"); //이용약관
        result = stplatManageService.selectStplatByPk(param);
        
        model.addAttribute("mtitle", result.get("STPLAT_SJ"));
        model.addAttribute("stplat_cn_html", result.get("STPLAT_CN_HTML"));
		
		return "gnrl/cs/usetext";
	}

	@RequestMapping(value="/usetext2")
	public String list2(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "고객지원");
        model.addAttribute("mtitle", "여행자약관");
        
		Map<String, String> param = new HashMap<String, String>();
		Map<String, String> result = new HashMap<String, String>();
		
		param.put("STPLAT_CODE", "000002"); //여행자약관
        result = stplatManageService.selectStplatByPk(param);
        
        model.addAttribute("mtitle", result.get("STPLAT_SJ"));
        model.addAttribute("stplat_cn_html", result.get("STPLAT_CN_HTML"));
		
		return "gnrl/cs/usetext";
	}

	@RequestMapping(value="/usetext3")
	public String list3(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "고객지원");
        model.addAttribute("mtitle", "개인정보취급방침");
        
		Map<String, String> param = new HashMap<String, String>();
		Map<String, String> result = new HashMap<String, String>();
		
		param.put("STPLAT_CODE", "000003"); //개인정보취급방침
        result = stplatManageService.selectStplatByPk(param);
        
        model.addAttribute("mtitle", result.get("STPLAT_SJ"));
        model.addAttribute("stplat_cn_html", result.get("STPLAT_CN_HTML"));
		
		return "gnrl/cs/usetext";
	}
}