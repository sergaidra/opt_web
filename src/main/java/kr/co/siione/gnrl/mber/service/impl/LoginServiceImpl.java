package kr.co.siione.gnrl.mber.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("LoginService")
@PropertySource("classpath:property/globals.properties")
public class LoginServiceImpl implements LoginService {

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
	@Resource
    private	MailManager mailManager;
	
	@Value("#{globals['server.ip']}")
	private String webserverip;


    public HashMap userInfo(HashMap map) throws Exception {
        return loginDAO.selectUserInfo(map);
    }

	public void userLog(HashMap map) throws Exception {
        loginDAO.insertUserLog(map);
	}
	
	public void connectLog(HashMap map) throws Exception {
        loginDAO.insertConnectLog(map);
	}	

    public int chkUserInfo(HashMap map) throws Exception {
        return loginDAO.chkUserInfo(map);
    }
    
    public String getMaxEsntlId(HashMap map) throws Exception {
        return loginDAO.getMaxEsntlId(map);
    }
    
	public void insertUser(HashMap map) throws Exception {
        loginDAO.insertUser(map);
        
        if("N".equals(String.valueOf(map.get("crtfc_at")))) {
    		// 메일 발송
    		Map<String, Object> attachMap = new HashMap<String, Object>();
    		attachMap.put("images", new ArrayList());
    		String subject = "원패스투어 회원가입을 위한 인증메일입니다.";
    		String content = "회원가입 인증을 하려면 <a href='http://" + webserverip + "/member/loginCert?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.";
    		mailManager.sendMail(subject, content, String.valueOf(map.get("email")), attachMap);	
        }
	}

    public int chkUserCert(HashMap map) throws Exception {
        return loginDAO.chkUserCert(map);
    }
	public void updateUserCert(HashMap map) throws Exception {
        loginDAO.updateUserCert(map);
	}

    public List<HashMap> chkUserInfoPw(HashMap map) throws Exception {
        return loginDAO.chkUserInfoPw(map);
    }

	public void updateCertKey(HashMap map) throws Exception {
        loginDAO.updateCertKey(map);
	}

	public void updatePassword(HashMap map) throws Exception {
        loginDAO.updatePassword(map);
	}
	
	public void sendPwSearchEmail(HashMap map) throws Exception {
		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());
		String subject = "원패스투어 비밀번호 찾기 메일입니다.";
		String content = "비밀번호를 재설정하려면 <a href='http://" + webserverip + "/member/pwsetup?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.";
		mailManager.sendMail(subject, content, String.valueOf(map.get("email")), attachMap);	
	}

    // 네이버 등에서도 사용할 수 있게 뺌.
    public void loginSuccess(HttpServletRequest request, HttpServletResponse response, HashMap result) throws Exception  {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();

        String esntl_id = (String) result.get("ESNTL_ID");
    	String password = (String) result.get("PASSWORD");
    	String crtfc_at = (String) result.get("CRTFC_AT");       
    	
		if("N".equals(crtfc_at)) {
			response.sendRedirect("/member/login/?result=certno");
			return;
		}
    	//중복로그인 여부 확인
    	if(loginManager.isUsing(esntl_id)){
    	    loginManager.removeSession(esntl_id);
    	}
    	
    	// 로그인 이력
    	HashMap map2 = new HashMap();
    	map2.put("esntl_id", esntl_id);
    	map2.put("conect_ip", UserUtils.getUserIp(request));
    	map2.put("conect_br", UserUtils.getUserBrower(request));
    	map2.put("conect_os", UserUtils.getUserOs(request));
    	UserUtils.log("접속정보", map2);
    	userLog(map2);
    	
    	session.setAttribute("user_id", result.get("USER_ID"));
    	session.setAttribute("user_nm", result.get("USER_NM"));
    	session.setAttribute("author_cl", result.get("AUTHOR_CL"));            	
    	session.setAttribute("email", result.get("EMAIL"));
    	session.setAttribute("esntl_id", esntl_id);
    	//timeout 30분
    	session.setMaxInactiveInterval(1800);

    	//새로운 접속(세션) 생성
    	loginManager.setSession(session, esntl_id);
    	
    	if("Y".equals(result.get("adminYn"))) { // 2017-11-21 임시(관리자모드에서 로그인하는 경우)
    		if(!result.get("AUTHOR_CL").equals("G")) {
    			response.sendRedirect("/mngr/");	
    		} else {
    			response.sendRedirect("/main/indexAction/");
    		}
    	} else {
    		response.sendRedirect("/main/indexAction/");	
    	}
    }

}
