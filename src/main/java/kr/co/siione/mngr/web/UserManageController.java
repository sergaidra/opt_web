package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.UserManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class UserManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "UserManageService")
	private UserManageService userManageService;

	@RequestMapping(value="/mngr/AdminManage/")
	public String AdminManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/AdminManage";
	}
	
	@RequestMapping(value="/mngr/UserManage/")
	public String UserManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/UserManage";
	}
	
	@RequestMapping(value="/mngr/selectUserList/")
	public void selectUserList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = userManageService.selectUserListCount(param);
			List<Map<String,Object>> results = userManageService.selectUserList(param);
			
			result.put("rows", cnt);
			result.put("data", results);
		} catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message", e.getLocalizedMessage());
		}
		
		jsonView.render(result, request, response);
	}	
	
	@RequestMapping(value="/mngr/updateUser/")
	public void updateUser(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("UPDT_ID", esntl_id);

		try {
			int iRe = userManageService.updateUser(param);
			
			if(iRe > 0 ) {
				result.put("success", true);
				result.put("message", "사용자 정보를 수정했습니다.");
			} else {
				result.put("success", false);
				result.put("message", "사용자 정보 수정 중 오류가 발생했습니다.");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

}