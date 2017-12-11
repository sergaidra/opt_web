package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.StplatManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class StplatManageController {
	
	protected Log log = LogFactory.getLog(this.getClass());

    @Inject
    MappingJackson2JsonView jsonView;

	@Resource(name = "StplatManageService")
	private StplatManageService stplatManageService;
	
	@RequestMapping(value="/mngr/StplatManage/")
	public String StplatManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/StplatManage";
	}

	@RequestMapping(value="/mngr/selectStplat/")
	public void selectStplat(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		
		Map<String, String> results = new HashMap<String, String>();
		Map<String, Object> result = new HashMap<String, Object>();
		
		UserUtils.log("selectStplat", param);

		try {
			results = stplatManageService.selectStplatByPk(param);
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
	
	@RequestMapping(value="/mngr/updateStplat/")
	public void updateStplat(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("UPDT_ID", esntl_id);

		try {
			int iRe = stplatManageService.updateStplat(param);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "수정 성공");
			} else {
				result.put("success", false);
				result.put("message", "수정 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}

}