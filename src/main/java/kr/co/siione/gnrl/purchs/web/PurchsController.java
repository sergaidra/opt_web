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
public class PurchsController {

	@Resource
    private PurchsService purchsService;
	@Resource
    private CartService cartService;
	
	@RequestMapping(value="/OrderList")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
			int point = purchsService.getTotalPoint(map);
			model.addAttribute("point", point);

		} catch(Exception e) {e.printStackTrace();}
		
        model.addAttribute("bp", "06");
       	model.addAttribute("btitle", "마이페이지");
        model.addAttribute("mtitle", "결제목록");
		
		return "gnrl/purchs/OrderList";
	}
	
	@RequestMapping(value="/addAction")
	public @ResponseBody ResponseVo addAction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
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

			String tot_setle_amount = UserUtils.nvl(param.get("tot_setle_amount"));
			String real_setle_amount = UserUtils.nvl(param.get("real_setle_amount"));
			String use_point = UserUtils.nvl(param.get("use_point"));
			String crtfc_no = "";
			String setle_ip = "";
			List<Map> lstCart = (List<Map>)param.get("lstCart");

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("tot_setle_amount", tot_setle_amount);
			map.put("real_setle_amount", real_setle_amount);
			map.put("use_point", use_point);
			map.put("crtfc_no", crtfc_no);
			map.put("setle_ip", setle_ip);
			map.put("lstCart", lstCart);

			UserUtils.log("[addPurchs-map]", map);
			
			purchsService.addPurchs(map);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
    @RequestMapping(value="/getPurchsList")
    public @ResponseBody Map<String, Object> getPurchsList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		String start_dt = UserUtils.nvl(param.get("start_dt"));
		String end_dt = UserUtils.nvl(param.get("end_dt"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 5 + 1;
		int endIdx = hidPage * 5;

    	map.put("esntl_id", esntl_id);   
    	map.put("start_dt", start_dt);
    	map.put("end_dt", end_dt);
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	System.out.println("[결제목록]map:"+map);
		int totalCount = purchsService.getPurchsListCount(map);
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	List<HashMap> list = purchsService.getPurchsList(map);    	
    	for(int i = 0; i < list.size(); i++) {
    		HashMap nMap = new HashMap();
    		nMap.put("CART_SN", list.get(i).get("CART_SN"));
    		list.get(i).put("OPTIONS", cartService.selectCartDetailList(nMap));    		
    	}
    	mapResult.put("list", list);

    	return mapResult;
    }

    @RequestMapping(value="/getPurchsReview")
    public @ResponseBody Map<String, Object> getPurchsReview(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();

		String purchs_sn = UserUtils.nvl(param.get("purchs_sn"));
		String cart_sn = UserUtils.nvl(param.get("cart_sn"));

    	map.put("purchs_sn", purchs_sn);   
    	map.put("cart_sn", cart_sn);
    	System.out.println("[getPurchsReview]map:"+map);
		HashMap review = purchsService.selectPurchsReview(map);
		if(review == null)
			review = new HashMap();
    	return review;
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
	    	
	    	purchsService.insertPurchsReview(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }

}
