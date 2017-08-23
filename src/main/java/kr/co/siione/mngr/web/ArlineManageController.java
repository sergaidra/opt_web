package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.ArlineManageService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class ArlineManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	private static final String ssUserId = "admin";

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "ArlineManageService")
	private ArlineManageService arlineManageService;

	@RequestMapping(value="/mngr/ArlineManage/")
	public String ArlineManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/ArlineManage";
	}

	@RequestMapping(value="/mngr/selectArlineList/")
	public void selectArlineList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();
		
		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		try {
			results = arlineManageService.selectArlineList(param);
		
			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}

	@RequestMapping(value="/mngr/saveArlineInfo/")
	public void saveTourClInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);
		
		try {
			result = arlineManageService.saveArlineInfo(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);    		
		}
		
		jsonView.render(result, request, response);
	} 


}