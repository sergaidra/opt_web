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
import kr.co.siione.gnrl.cs.service.FaqService;
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
@RequestMapping(value = "/cs/")
public class FaqController {

	@Resource
	private FaqService faqService;

	private static final Logger LOG = LoggerFactory.getLogger(LiveViewController.class);

	@RequestMapping(value="/faq")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "FAQ");
        model.addAttribute("mtitle", "");
		
		return "gnrl/cs/faq";
	}

    @RequestMapping(value="/getFaqList")
    public @ResponseBody Map<String, Object> getFaqList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	String subcategory = UserUtils.nvl(param.get("subcategory"));
    	String keyword = UserUtils.nvl(param.get("keyword"));
    	map.put("subcategory", subcategory);
    	map.put("keyword", keyword);
    	System.out.println("[getFaqList]map:"+map);
    	
    	List<HashMap> list = faqService.selectBbsList(map);   	

    	mapResult.put("list", list);

    	return mapResult;
    }
    
    @RequestMapping(value="/viewFaq")
    public @ResponseBody Map<String, Object> viewFaq(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));
    	map.put("bbs_sn", bbs_sn);
    	System.out.println("[viewFaq]map:"+map);
    	
    	map = faqService.viewBbs(map);	

    	mapResult.put("data", map);

    	return mapResult;
    }


	@RequestMapping(value="/saveFaq")
	public @ResponseBody ResponseVo saveFaq(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String category = "F";
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));
			String subcategory = UserUtils.nvl(param.get("subcategory"));
			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	
			map.put("subcategory", subcategory);	
			map.put("bbs_sn", bbs_sn);	

			UserUtils.log("[saveFaq-map]", map);
			
			if("".equals(bbs_sn)) {
				faqService.insertBbs(map);
			} else {
				faqService.updateBbs(map);
			}
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
}