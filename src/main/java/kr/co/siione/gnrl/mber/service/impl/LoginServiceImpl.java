package kr.co.siione.gnrl.mber.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cs.service.impl.ReviewDAO;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.gnrl.purchs.service.impl.PointDAO;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;

@Service("LoginService")
@PropertySource("classpath:property/globals.properties")
public class LoginServiceImpl implements LoginService {

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	@Resource(name = "pointDAO")
	private PointDAO pointDAO;

	@Resource
    private	MailManager mailManager;
	
	@Value("#{globals['server.ip']}")
	private String webserverip;
	@Value("#{globals['server.domain']}")
	private String webserverdomain;


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
    
	private String getMailHtml() {
		StringBuilder builder = new StringBuilder();
		org.springframework.core.io.Resource resource = new ClassPathResource("html/mail.htm"); 
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(resource.getInputStream(), "UTF-8"));
			String line = null;
            while ((line = reader.readLine()) != null)
                builder.append(line);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return builder.toString();
	}	

	public void insertUser(HashMap map) throws Exception {
        loginDAO.insertUser(map);
        
        // 신규회원 포인트 적립
		HashMap mapP = new HashMap();
		mapP.put("point", "10000");
		mapP.put("esntl_id", map.get("esntl_id"));
		mapP.put("accml_se", "J");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.YEAR, 1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		mapP.put("valid_de", sdf.format(cal.getTime()));
		pointDAO.insertPoint(mapP);
		
		// 1000번째 신규회원
		if(loginDAO.getUserCount() == 1000) {
			mapP.put("point", "100000");
			mapP.put("accml_se", "T");
			pointDAO.insertPoint(mapP);		
		}
        
        if("N".equals(String.valueOf(map.get("crtfc_at")))) {
    		// 메일 발송
    		Map<String, Object> attachMap = new HashMap<String, Object>();
    		attachMap.put("images", new ArrayList());
    		String subject = "원패스투어 회원가입을 위한 인증메일입니다.";
    		String content = getMailHtml();
    		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
    		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
    		content = content.replaceAll("[$]\\{title\\}", "원패스투어 회원가입을 위한 인증메일입니다.");
    		content = content.replaceAll("[$]\\{title2\\}", "");
    		content = content.replaceAll("[$]\\{contents\\}", "회원가입 인증을 하려면 <a href='http://" + webserverip + "/member/loginCert?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.");
    		
    		//String content = "회원가입 인증을 하려면 <a href='http://" + webserverip + "/member/loginCert?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.";
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
		String content = getMailHtml();
		content = content.replaceAll("[$]\\{webserverip\\}", webserverip);
		content = content.replaceAll("[$]\\{webserverdomain\\}", webserverdomain);		
		content = content.replaceAll("[$]\\{title\\}", "원패스투어 비밀번호 찾기 메일입니다.");
		content = content.replaceAll("[$]\\{title2\\}", "");
		content = content.replaceAll("[$]\\{contents\\}", "비밀번호를 재설정하려면 <a href='http://" + webserverip + "/member/pwsetup?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.");
		
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
    	//timeout 30분->1시간으로 변경
    	session.setMaxInactiveInterval(3600);

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
    
    public HashMap viewUserInfo(HashMap map) throws Exception {
    	return loginDAO.viewUserInfo(map);
    }

    public void modifyUser(HashMap map) throws Exception {
    	loginDAO.modifyUser(map);
    }
}
