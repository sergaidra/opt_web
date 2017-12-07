package kr.co.siione.gnrl.mber.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.MailManager;

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

    public int chkUserInfo(HashMap map) throws Exception {
        return loginDAO.chkUserInfo(map);
    }
    
    public String getMaxEsntlId(HashMap map) throws Exception {
        return loginDAO.getMaxEsntlId(map);
    }
    
	public void insertUser(HashMap map) throws Exception {
        loginDAO.insertUser(map);
        
		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());
		String subject = "원패스투어 회원가입을 위한 인증메일입니다.";
		String content = "회원가입 인증을 하려면 <a href='http://" + webserverip + "/member/loginCert?key=" + String.valueOf(map.get("certkey")) + "' target='_blank'>[여기]</a>를 클릭하세요.";
		mailManager.sendMail(subject, content, String.valueOf(map.get("email")), attachMap);	
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

}
