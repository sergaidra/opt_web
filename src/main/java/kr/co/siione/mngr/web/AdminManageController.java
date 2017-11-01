package kr.co.siione.mngr.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
}