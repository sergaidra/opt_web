package kr.co.siione.gnrl.mber.web;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONObject;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;


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
        String adminYn = SimpleUtils.default_set(request.getParameter("adminYn"));

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
            	
            	// 로그인 이력
            	HashMap map2 = new HashMap();
            	map2.put("esntl_id", esntl_id);
            	map2.put("conect_ip", getUserIp(request));
            	map2.put("conect_br", getUserBrower(request));
            	map2.put("conect_os", getUserOs(request));
            	UserUtils.log("접속정보", map2);
            	loginService.userLog(map2);
            	
            	session.setAttribute("user_id", result.get("USER_ID"));
            	session.setAttribute("user_nm", result.get("USER_NM"));
            	session.setAttribute("author_cl", result.get("AUTHOR_CL"));            	
            	session.setAttribute("esntl_id", esntl_id);
            	//timeout 30분
            	session.setMaxInactiveInterval(1800);

            	//새로운 접속(세션) 생성
            	loginManager.setSession(session, esntl_id);
            	
            	if(adminYn.equals("Y")) { // 2017-11-21 임시(관리자모드에서 로그인하는 경우)
            		if(!result.get("AUTHOR_CL").equals("G")) {
            			response.sendRedirect("/mngr/");	
            		} else {
            			response.sendRedirect("/main/indexAction/");
            		}
            	} else {
            		response.sendRedirect("/main/indexAction/");	
            	}
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
    
	public static String getUserIp(HttpServletRequest request){
		//HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null || ip.length() == 0) {
		   ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0) {
		   ip = request.getHeader("WL-Proxy-Client-IP");  // 웹로직
		}
		if (ip == null || ip.length() == 0) {
		   ip = request.getRemoteAddr() ;
		}
		return ip;
	}
	
	public static String getUserBrower(HttpServletRequest request){
		String agent = request.getHeader("User-Agent");
		String brower = null;
		 
		if (agent != null) {
		   if (agent.indexOf("Trident") > -1) {
		      brower = "MSIE";
		   } else if (agent.indexOf("Chrome") > -1) {
		      brower = "Chrome";
		   } else if (agent.indexOf("Opera") > -1) {
		      brower = "Opera";
		   } else if (agent.indexOf("iPhone") > -1 && agent.indexOf("Mobile") > -1) {
		      brower = "iPhone";
		   } else if (agent.indexOf("Android") > -1 && agent.indexOf("Mobile") > -1) {
		      brower = "Android";
		   }
		}
		return brower;
	}	
	
	public static String getUserOs(HttpServletRequest request){
		String agent = request.getHeader("User-Agent");
		String os = null;
		 
		if(agent.indexOf("NT 6.0") != -1) os = "Windows Vista/Server 2008";
		else if(agent.indexOf("NT 5.2") != -1) os = "Windows Server 2003";
		else if(agent.indexOf("NT 5.1") != -1) os = "Windows XP";
		else if(agent.indexOf("NT 5.0") != -1) os = "Windows 2000";
		else if(agent.indexOf("NT") != -1) os = "Windows NT";
		else if(agent.indexOf("9x 4.90") != -1) os = "Windows Me";
		else if(agent.indexOf("98") != -1) os = "Windows 98";
		else if(agent.indexOf("95") != -1) os = "Windows 95";
		else if(agent.indexOf("Win16") != -1) os = "Windows 3.x";
		else if(agent.indexOf("Windows") != -1) os = "Windows";
		else if(agent.indexOf("Linux") != -1) os = "Linux";
		else if(agent.indexOf("Macintosh") != -1) os = "Macintosh";
		else os = ""; 
		
		return os;
	}
	
	
}
