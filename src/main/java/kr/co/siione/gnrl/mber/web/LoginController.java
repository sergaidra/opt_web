package kr.co.siione.gnrl.mber.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.Utility;

import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import twitter4j.internal.org.json.JSONObject;

@Controller
@RequestMapping(value = "/mber/")
public class LoginController {

	@Resource
    private LoginService loginService;
    
    @RequestMapping(value="/login/")
    public String login(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String userID = SimpleUtils.default_set((String)session.getAttribute("userID"));
        String userNm = SimpleUtils.default_set((String)session.getAttribute("userNm"));
        

        

int test1 = session.getMaxInactiveInterval();
Date test2 = new Date(session.getCreationTime());
Date test3 = new Date(session.getLastAccessedTime());        
        
        model.addAttribute("userID", userID);
        model.addAttribute("userNm", userNm);
        model.addAttribute("userCnt", Integer.valueOf(loginManager.getUserCount()));
        String result = SimpleUtils.default_set(request.getParameter("result"));
        model.addAttribute("result", result);
        
        
        return "uia/login";
    }

    @RequestMapping(value="/loginAction/")
    public void loginAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String userID = SimpleUtils.default_set(request.getParameter("userID"));
        String userPW = SimpleUtils.default_set(request.getParameter("userPW"));
        
        ArrayList u = new ArrayList();
        u.add("shkim");
        u.add("gdhong");
        u.add("mdkim");
        if(u.contains(userID)){
        	//중복로그인 여부 확인
        	if(loginManager.isUsing(userID)){
        	    //기존의 접속(세션)을 끊는다.
        	    loginManager.removeSession(userID);
        	}

        	//관리되는 세션정보들
        	session.setAttribute("userID", userID);
        	session.setAttribute("userNm", "홍길동");
        	//timeout 10분
        	session.setMaxInactiveInterval(600);

        	//새로운 접속(세션) 생성
        	loginManager.setSession(session, userID);
        	response.sendRedirect("/uia/login/");
        } else {
            response.sendRedirect("/uia/login/?result=fail");
        }
    }

    @RequestMapping(value="/logout/")
    public void logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("/uia/login/");
    }

    @RequestMapping(value="/sessionAlive/")
    public ResponseEntity sessionAlive(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        JSONObject obj = new JSONObject();
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/plain; charset=utf-8");
        HttpSession session = request.getSession();
        String userID = SimpleUtils.default_set((String)session.getAttribute("userID"));

        if(userID == null || userID.isEmpty()){
            obj.put("RESULT", -1);
        }else{
            obj.put("RESULT", 0);
        }
        entity = new ResponseEntity(obj.toString(), responseHeaders, HttpStatus.CREATED);
        return entity;
    }

    @RequestMapping(value="/sessionTimeout/")
    public String sessionTimeout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();        

		int interval = session.getMaxInactiveInterval();
		Date ctime = new Date(session.getCreationTime());
		Date ltime = new Date(session.getLastAccessedTime());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");		 
		String cdate = sdf.format(ctime);		 
		String ldate = sdf.format(ltime);

        model.addAttribute("interval", interval);
        model.addAttribute("ctime", cdate);
        model.addAttribute("ltime", ldate);

        return "uia/sessionTimeout";
    }
}
