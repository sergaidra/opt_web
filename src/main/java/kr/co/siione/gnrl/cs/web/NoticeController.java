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
import kr.co.siione.gnrl.cs.service.NoticeService;
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
public class NoticeController {

	@Resource
	private NoticeService noticeService;
	
	@Resource
	private BbsService bbsService;

	private static final Logger LOG = LoggerFactory.getLogger(NoticeController.class);

	@RequestMapping(value="/notice")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
        model.addAttribute("category", "N");

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "공지사항");
        model.addAttribute("mtitle", "");
		
		return "gnrl/cs/notice";
	}

    @RequestMapping(value="/viewNotice")
    public @ResponseBody Map<String, Object> viewNotice(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));
    	map.put("bbs_sn", bbs_sn);
    	System.out.println("[viewNotice]map:"+map);
    	bbsService.updateBbsViewCnt(map);
    	
    	map = noticeService.viewBbs(map);	

    	mapResult.put("data", map);

    	return mapResult;
    }


	@RequestMapping(value="/saveNotice")
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

			String category = "N";
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

}