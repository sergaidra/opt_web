package kr.co.siione.gnrl.mber.service.impl;

import java.util.HashMap;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.mber.service.LoginService;

@Service("LoginService")
public class LoginServiceImpl implements LoginService {

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
    public HashMap userInfo(HashMap map) throws Exception {
        return loginDAO.selectUserInfo(map);
    }

	public void userLog(HashMap map) throws Exception {
        loginDAO.insertUserLog(map);
	}

	public void joinMeber(HashMap map) throws Exception {		
        String esntl_id = loginDAO.selectEsntlID(map);
		map.put("esntl_id", esntl_id);

        loginDAO.insertUser(map);
	}
}
