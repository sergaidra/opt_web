package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.PointManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class PointManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "PointManageService")
	private PointManageService pointManageService;

	@RequestMapping(value="/mngr/UserPointManage/")
	public String UserPointManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/UserPointManage";
	}
	
	@RequestMapping(value="/mngr/selectPointList/")
	public void selectPointList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = pointManageService.selectPointListCount(param);
			List<Map<String,Object>> results = pointManageService.selectPointList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	

	@RequestMapping(value="/mngr/selectPurchsPointList/")
	public void selectPurchsPointList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = pointManageService.selectPurchsPointListCount(param);
			List<Map<String,Object>> results = pointManageService.selectPurchsPointList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectUserPointList/")
	public void selectUserPointList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = pointManageService.selectUserPointListCount(param);
			List<Map<String,Object>> results = pointManageService.selectUserPointList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectUserPointSum/")
	public void selectUserPointSum(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> count = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			count = pointManageService.selectUserPointSum(param);
			
			result.put("data", count);			
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("CF_SUM", 0);
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
}