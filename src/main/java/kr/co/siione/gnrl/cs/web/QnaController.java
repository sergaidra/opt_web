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
import kr.co.siione.gnrl.cs.service.QnaService;
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
public class QnaController {

	@Resource
	private QnaService qnaService;

	private static final Logger LOG = LoggerFactory.getLogger(QnaController.class);

	@RequestMapping(value="/qna")
	public String qna(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

        model.addAttribute("bp", "07");
        model.addAttribute("btitle", "고객지원");
       	model.addAttribute("mtitle", "1:1 문의하기");
		
		return "gnrl/cs/qna";
	}
	
    @RequestMapping(value="/getOpinion")
    public @ResponseBody Map getOpinion(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession(); 
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String author_cl = UserUtils.nvl((String)session.getAttribute("author_cl"));

    	String goods_code = UserUtils.nvl(param.get("goods_code"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 5 + 1;
		int endIdx = hidPage * 5;

    	map.put("esntl_id", esntl_id);   
    	if("A".equals(author_cl) || "M".equals(author_cl))
    		map.put("author_cl", author_cl);   
    	map.put("goods_code", goods_code); 
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	
    	int totalCount = qnaService.getOpinionListCount(map);
    	List<HashMap> list = qnaService.getOpinionList(map);
    	
    	/*
    	List<HashMap> result = new ArrayList();
    	
    	for(int i = 0; i < list.size(); i++) {
    		result.add(list.get(i));
    		HashMap mapChild = new HashMap();
    		mapChild.put("parent_opinion_sn", list.get(i).get("OPINION_SN"));
    		List<HashMap> lstChild = qnaService.getOpinionAnswerList(mapChild);
    		result.addAll(lstChild);
    	}
    	*/
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("startIdx", String.valueOf(startIdx));
    	mapResult.put("list", list);

    	return mapResult;    
    }    

    @RequestMapping(value="/popupOpinion")
    public String popupFlight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
      	HashMap map = new HashMap();

		String opinion_sn = UserUtils.nvl(request.getParameter("opinion_sn"));
		String goods_code = UserUtils.nvl(request.getParameter("goods_code"));
		String callback = UserUtils.nvl(request.getParameter("callback"));		
		String mode = UserUtils.nvl(request.getParameter("mode"));		

    	map.put("opinion_sn", opinion_sn);   
    	map.put("goods_code", goods_code);   
    	System.out.println("[viewOpinion]map:"+map);
		HashMap opinion = qnaService.viewOpinion(map);
		
		model.addAttribute("opinion", opinion);
		model.addAttribute("opinion_sn", opinion_sn);
		model.addAttribute("goods_code", goods_code);
		model.addAttribute("callback", callback);
		model.addAttribute("mode", mode);
		
		return "gnrl/popup/opinion";	
    }	
	
    @RequestMapping(value="/saveOpinion")
    public @ResponseBody ResponseVo saveOpinion(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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

			HashMap map = new HashMap();

			String opinion_sn = UserUtils.nvl(param.get("opinion_sn"));
			String goods_code = UserUtils.nvl(param.get("goods_code"));
			String opinion_sj = UserUtils.nvl(param.get("opinion_sj"));
			String opinion_cn = UserUtils.nvl(param.get("opinion_cn"));
			String parent_opinion_sn = UserUtils.nvl(param.get("parent_opinion_sn"));

	    	map.put("opinion_sn", opinion_sn);
	    	map.put("goods_code", goods_code);
	    	map.put("opinion_sj", opinion_sj);
	    	map.put("opinion_cn", opinion_cn);
	    	map.put("esntl_id", esntl_id);
	    	map.put("parent_opinion_sn", parent_opinion_sn);
	    	
	    	if("".equals(opinion_sn))
	    		qnaService.insertOpinion(map);
	    	else
	    		qnaService.updateOpinion(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }    
    
    @RequestMapping(value="/deleteOpinion")
    public @ResponseBody ResponseVo deleteOpinion(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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

			HashMap map = new HashMap();

			String opinion_sn = UserUtils.nvl(param.get("opinion_sn"));
			String opinion_sj = UserUtils.nvl(param.get("opinion_sj"));
			String opinion_cn = UserUtils.nvl(param.get("opinion_cn"));
			String delete_mode = UserUtils.nvl(param.get("delete_mode"));
			String parent_opinion_sn = UserUtils.nvl(param.get("parent_opinion_sn"));
			String goods_code = UserUtils.nvl(param.get("goods_code"));

	    	map.put("esntl_id", esntl_id);
	    	map.put("opinion_sn", opinion_sn);
	    	map.put("opinion_sj", opinion_sj);
	    	map.put("opinion_cn", opinion_cn);
	    	map.put("delete_mode", delete_mode);
	    	map.put("parent_opinion_sn", parent_opinion_sn);
	    	map.put("goods_code", goods_code);
	    	
	    	qnaService.deleteOpinion(map);
	    	
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }        
}