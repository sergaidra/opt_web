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
		map.addAttribute("ssAuthorCl", author_cl);
		
		return "/mngr/MngrMain";	
	}
	
	@RequestMapping(value="/mngr/login/")
	public String mngrLogin(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));
        String user_nm = SimpleUtils.default_set((String)session.getAttribute("user_nm"));
        
        model.addAttribute("user_id", user_id);
        model.addAttribute("user_nm", user_nm);
        model.addAttribute("userCnt", Integer.valueOf(loginManager.getUserCount()));
        String result = SimpleUtils.default_set(request.getParameter("result"));
        model.addAttribute("result", result);
		
		return "/mngr/login";	
	} 
}