package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.ExchangeService;
import kr.co.siione.mngr.service.PurchsManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class PurchsManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "PurchsManageService")
	private PurchsManageService purchsManageService;
	@Resource(name = "ExchangeService")
	private ExchangeService exchangeService;

	@RequestMapping(value="/mngr/PurchsManage/")
	public String PurchsManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/PurchsManage";
	}
	
	@RequestMapping(value="/mngr/PurchsTourManage/")
	public String PurchsTourManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
				
		return "/mngr/PurchsTourManage";
	}
	
	@RequestMapping(value="/mngr/PayManage/")
	public String PayManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
				
		return "/mngr/PayManage";
	}

	@RequestMapping(value="/mngr/OrderWaitManage/")
	public String OrderWaitManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/OrderWaitManage";
	}

	@RequestMapping(value="/mngr/selectPurchsList/")
	public void selectPurchsList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPurchsList", param);
		try {
			int cnt = purchsManageService.selectPurchsListCount(param);
			List<Map<String,Object>> results = purchsManageService.selectPurchsList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/selectPurchsListExcel/")
    public ModelAndView selectPurchsExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
       	Map<String, Object> result = new HashMap<String, Object>();
       	UserUtils.log("selectPurchsListExcel", param);		
    	try {
    		int cnt = purchsManageService.selectPurchsListCount(param);
			param.put("limit", String.valueOf(cnt));
			param.put("page" , "1");
			param.put("start", "0");
			
    		List<Map<String,Object>> results = purchsManageService.selectPurchsList(param);

			result.put("CHILD", results);
    	} catch (Exception e) {
    		result.put("CHILD", null);
			log.error(e.getMessage());
    	}
		return new ModelAndView("PurchsListExcel", "modelMap", result);
    } 	
	

	@RequestMapping(value="/mngr/selectPurchsGoodsList/")
	public void selectPurchsGoodsList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPurchsGoodsList", param);
		try {
			List<Map<String,Object>> results = purchsManageService.selectPurchsGoodsList(param);
			System.out.println(results);
			result.put("rows", results.size());
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/selectPurchsGoodsListExcel/")
	public ModelAndView selectPurchsGoodsListExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPurchsGoodsListExcel", param);		
		try {
			int cnt = purchsManageService.selectPurchsListCount(param);
			param.put("limit", String.valueOf(cnt));
			param.put("page" , "1");
			param.put("start", "0");
			
			List<Map<String,Object>> results = purchsManageService.selectPurchsGoodsList(param);

			result.put("CHILD", results);
		} catch (Exception e) {
			result.put("CHILD", null);
			log.error(e.getMessage());
		}
		return new ModelAndView("PurchsGoodsListExcel", "modelMap", result);
	}
	
	@RequestMapping(value="/mngr/selectPurchsListForSchdul/")
	public void selectPurchsListForSchdul(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPurchsListForSchdul", param);
		try {
			int cnt = purchsManageService.selectPurchsListForSchdulCount(param);
			List<Map<String,String>> results = purchsManageService.selectPurchsListForSchdul(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/selectPayList/")
	public void selectPayList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPayList", param);
		try {
			//int cnt = purchsManageService.selectPurchsListForSchdulCount(param);
			List<Map<String,String>> results = purchsManageService.selectPayList(param);
			
			result.put("rows", results.size());
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/refundPurchs/")
	public void refundPurchs(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectPayList", param);
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		param.put("REFUND_PROC_ID", esntl_id);

		try {
			int iRe = purchsManageService.refundPurchs(param);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "환불처리 성공");
			} else {
				result.put("success", false);
				result.put("message", "환불처리 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectOrderWaitList/")
	public void selectOrderWaitList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectOrderWaitList", param);
		try {
			int cnt = purchsManageService.selectOrderWaitListCount(param);
			List<Map<String,Object>> results = purchsManageService.selectOrderWaitList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/selectOrderWaitListExcel/")
    public ModelAndView selectOrderWaitListExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
       	Map<String, Object> result = new HashMap<String, Object>();
       	UserUtils.log("selectOrderWaitListExcel", param);		
    	try {
    		int cnt = purchsManageService.selectOrderWaitListCount(param);
			param.put("limit", String.valueOf(cnt));
			param.put("page" , "1");
			param.put("start", "0");
			
    		List<Map<String,Object>> results = purchsManageService.selectOrderWaitList(param);

			result.put("CHILD", results);
    	} catch (Exception e) {
    		result.put("CHILD", null);
			log.error(e.getMessage());
    	}
		return new ModelAndView("PurchsListExcel", "modelMap", result);
    } 	

	@RequestMapping(value="/mngr/updateReservationStatus/")
	public void updateReservationStatus(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("updateReservationStatus", param);
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		try {
			int iRe = purchsManageService.updateReservationStatus(param);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "확인완료 처리 성공");
			} else {
				result.put("success", false);
				result.put("message", "확인완료 처리 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/ExchangeManage/")
	public String ExchangeManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/ExchangeManage";
	}

	@RequestMapping(value="/mngr/selectExchangeList/")
	public void selectExchangeList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectExchangeList", param);
		try {
			int cnt = exchangeService.selectExchangeListCount(param);
			List<Map<String,Object>> results = exchangeService.selectExchangeList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	

	@RequestMapping(value="/mngr/selectExchangeHistoryList/")
	public void selectExchangeHistoryList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log("selectExchangeHistoryList", param);
		try {
			int cnt = exchangeService.selectExchangeHistoryListCount(param);
			List<Map<String,Object>> results = exchangeService.selectExchangeHistoryList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	

	@RequestMapping(value="/mngr/selectExchangeListExcel/")
    public ModelAndView selectExchangeListExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
       	Map<String, Object> result = new HashMap<String, Object>();
       	UserUtils.log("selectExchangeListExcel", param);		
    	try {
    		int cnt = exchangeService.selectExchangeListCount(param);
			param.put("limit", String.valueOf(cnt));
			param.put("page" , "1");
			param.put("start", "0");
			
    		List<Map<String,Object>> results = exchangeService.selectExchangeList(param);

			result.put("CHILD", results);
    	} catch (Exception e) {
    		result.put("CHILD", null);
			log.error(e.getMessage());
    	}
		return new ModelAndView("PurchsListExcel", "modelMap", result);
    } 	
}