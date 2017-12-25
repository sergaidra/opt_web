package kr.co.siione.gnrl.cs.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import kr.co.siione.gnrl.cs.service.ReviewService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.purchs.service.PurchsService;
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
public class ReviewController {

	@Resource
	private ReviewService reviewService;
	
	@Resource
    private PurchsService purchsService;

	private static final Logger LOG = LoggerFactory.getLogger(ReviewController.class);

	@RequestMapping(value="/review")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행후기");
        model.addAttribute("mtitle", "");
		
		return "gnrl/cs/review";
	}

    @RequestMapping(value="/getReviewList")
    public @ResponseBody Map<String, Object> getReviewList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int pageSize = 5;
		int startIdx = (hidPage - 1) * pageSize + 1;
		int endIdx = hidPage * pageSize;

    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	System.out.println("[getReviewList]map:"+map);
		int totalCount = reviewService.getReviewListCount(map);
    	List<HashMap> list = reviewService.getReviewList(map);    	

    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("list", list);
    	mapResult.put("startIdx", startIdx);

    	return mapResult;
    }

    
    @RequestMapping(value="/popupReview")
    public String popupFlight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
      	HashMap map = new HashMap();

		String purchs_sn = UserUtils.nvl(request.getParameter("purchs_sn"));
		String cart_sn = UserUtils.nvl(request.getParameter("cart_sn"));
		String goods_code = UserUtils.nvl(request.getParameter("goods_code"));
		String callback = UserUtils.nvl(request.getParameter("callback"));		

    	map.put("purchs_sn", purchs_sn);   
    	map.put("cart_sn", cart_sn);
    	System.out.println("[getPurchsReview]map:"+map);
		HashMap review = reviewService.selectPurchsReview(map);
		HashMap purchs = purchsService.viewPurchs(map);
		
		model.addAttribute("review", review);
		model.addAttribute("purchs", purchs);
		model.addAttribute("purchs_sn", purchs_sn);
		model.addAttribute("cart_sn", cart_sn);
		model.addAttribute("goods_code", goods_code);
		model.addAttribute("callback", callback);
		
		return "gnrl/popup/review";	
    }	

    @RequestMapping(value="/savePurchsReview")
    public @ResponseBody ResponseVo savePurchsReview(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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

			String purchs_sn = UserUtils.nvl(param.get("purchs_sn"));
			String cart_sn = UserUtils.nvl(param.get("cart_sn"));
			String goods_code = UserUtils.nvl(param.get("goods_code"));
			String review_cn = UserUtils.nvl(param.get("review_cn"));
			String review_score = UserUtils.nvl(param.get("review_score"));

	    	map.put("purchs_sn", purchs_sn);   
	    	map.put("cart_sn", cart_sn);
	    	map.put("goods_code", goods_code);
	    	map.put("review_cn", review_cn);
	    	map.put("review_score", review_score);
	    	map.put("esntl_id", esntl_id);
			map.put("accml_se", "A");
			map.put("point", "0");
			map.put("valid_de", "20181231");
			map.put("valid_dt", "20181231");	// TB_POINT 용
			map.put("pointYn", "N");
			
			List<HashMap> mPurchs = purchsService.selectPurchsDetail(map);
			if(mPurchs.size() > 0) {
				int REAL_SETLE_AMOUNT = Integer.parseInt(String.valueOf(mPurchs.get(0).get("REAL_SETLE_AMOUNT")));
				String PURCHS_DE = String.valueOf(mPurchs.get(0).get("PURCHS_DE"));
				map.put("point", String.valueOf((int)(REAL_SETLE_AMOUNT / 1000)));
				// 일주일 전인지 계산
				Calendar cal = Calendar.getInstance();
				cal.set(Calendar.DATE, -7);
				SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
				String beforeWeek = format.format(cal.getTime());
				if(beforeWeek.compareTo(PURCHS_DE) <= 0)
					map.put("pointYn", "Y");
			}
			
	    	System.out.println("[savePurchsReview]map:"+map);
	    	
	    	reviewService.insertPurchsReview(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }

    @RequestMapping(value="/deletePurchsReview")
    public @ResponseBody ResponseVo deletePurchsReview(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
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

			String purchs_sn = UserUtils.nvl(param.get("purchs_sn"));
			String cart_sn = UserUtils.nvl(param.get("cart_sn"));

	    	map.put("purchs_sn", purchs_sn);   
	    	map.put("cart_sn", cart_sn);
	    	map.put("esntl_id", esntl_id);
	    	
			
	    	System.out.println("[deletePurchsReview]map:"+map);
	    	
	    	reviewService.deletePurchsReview(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }

}