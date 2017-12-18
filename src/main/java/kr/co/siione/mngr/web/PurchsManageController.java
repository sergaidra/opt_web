package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

	@RequestMapping(value="/mngr/PurchsManage/")
	public String PurchsManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/PurchsManage";
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
}