package kr.co.siione.gnrl.mber.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.LoginManager;

import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import twitter4j.internal.org.json.JSONObject;

@Controller
@RequestMapping(value = "/member/")
public class LoginController {

	@Resource
    private LoginService loginService;
    
    @RequestMapping(value="/login/")
    public String login(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
        
        
        return "gnrl/mber/login";
    }

    @RequestMapping(value="/loginAction/")
    public void loginAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String user_id = SimpleUtils.default_set(request.getParameter("txtID"));
        String user_pw = SimpleUtils.default_set(request.getParameter("txtPW"));

    	HashMap map = new HashMap();
    	map.put("user_id", user_id);
    	HashMap result = loginService.userInfo(map);

        if(result != null){

        	String esntl_id = (String) result.get("ESNTL_ID");
        	String password = (String) result.get("PASSWORD");

        	//password
        	if(user_pw.equals(password)){
            	//중복로그인 여부 확인
            	if(loginManager.isUsing(esntl_id)){
            	    loginManager.removeSession(esntl_id);
            	}

            	session.setAttribute("user_id", result.get("USER_ID"));
            	session.setAttribute("user_nm", result.get("USER_NM"));
            	session.setAttribute("esntl_id", esntl_id);
            	//timeout 30분
            	session.setMaxInactiveInterval(1800);

            	//새로운 접속(세션) 생성
            	loginManager.setSession(session, esntl_id);
            	response.sendRedirect("/main/indexAction/");
        	}else{
                response.sendRedirect("/member/login/?result=fail");
        	}
        } else {
            response.sendRedirect("/member/login/?result=fail");
        }
    }

    @RequestMapping(value="/logoutAction/")
    public void logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("/main/indexAction/");
    }

    @RequestMapping(value="/aliveJson/")
    public ResponseEntity sessionAlive(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        JSONObject obj = new JSONObject();
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/plain; charset=utf-8");
        HttpSession session = request.getSession();
        String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));

        if(user_id == null || user_id.isEmpty()){
            obj.put("RESULT", -1);
        }else{
            obj.put("RESULT", 0);
        }
        entity = new ResponseEntity(obj.toString(), responseHeaders, HttpStatus.CREATED);
        return entity;
    }

    @RequestMapping(value="/timerIframe/")
    public String sessionTimeout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/mber/timer";
    }
    
}
