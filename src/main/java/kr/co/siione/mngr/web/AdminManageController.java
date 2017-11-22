package kr.co.siione.mngr.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.UserUtils;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminManageController {

	@RequestMapping(value={"/mngr/", "/mngr/main/"})
	public String mngrMain(HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {

		HttpSession session = request.getSession();
		String author_cl = UserUtils.nvl((String)session.getAttribute("author_cl"));
		String user_id = UserUtils.nvl((String)session.getAttribute("user_id"));
		String user_nm = UserUtils.nvl((String)session.getAttribute("user_nm"));
		map.addAttribute("ssAuthorCl", author_cl);
		map.addAttribute("ssUserId", user_id);
		map.addAttribute("ssUserNm", user_nm);

		return "/mngr/MngrMain";
	}

	@RequestMapping(value="/mngr/login/")
	public String mngrLogin(HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {

		LoginManager loginManager = LoginManager.getInstance();
		HttpSession session = request.getSession();
		String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));
		String user_nm = SimpleUtils.default_set((String)session.getAttribute("user_nm"));
		map.addAttribute("user_id", user_id);
		map.addAttribute("user_nm", user_nm);
		map.addAttribute("userCnt", Integer.valueOf(loginManager.getUserCount()));
		String result = SimpleUtils.default_set(request.getParameter("result"));
		map.addAttribute("result", result);

		return "/mngr/login";
	}
}