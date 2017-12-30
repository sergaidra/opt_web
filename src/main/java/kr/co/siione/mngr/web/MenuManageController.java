package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.MenuManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class MenuManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "MenuManageService")
	private MenuManageService menuManageService;

	@RequestMapping(value="/mngr/MenuManage/")
	public String MenuManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/MenuManage";
	}
	
	@RequestMapping(value="/mngr/selectMenuList/")
	public void selectMenuList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			List<Map<String,Object>> results = menuManageService.selectMenuList(param);
			
			result.put("rows", results.size());
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/selectUpperMenuTree/")
	public void selectUpperMenuTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		UserUtils.log("[selectUpperMenuTree]param:", param);
		
		try {
			List<Map<String,Object>> results = menuManageService.selectUpperMenuTree(param);
			
			result.put("rows", results.size());
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectMenuTree/")
	public void selectMenuTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		UserUtils.log("[selectMenuTree]param:", param);
		
		try {
			List<Map<String,Object>> results = menuManageService.selectMenuTree(param);
			
			result.put("rows", results.size());
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/saveMenuInfo/")
	public void saveMenuInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

		try {
			result = menuManageService.saveMenuInfo(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	
}