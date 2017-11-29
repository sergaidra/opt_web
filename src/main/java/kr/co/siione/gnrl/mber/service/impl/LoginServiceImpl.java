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

    public int chkUserInfo(HashMap map) throws Exception {
        return loginDAO.chkUserInfo(map);
    }
	public void insertUser(HashMap map) throws Exception {
        loginDAO.insertUser(map);
	}

    public int chkUserCert(HashMap map) throws Exception {
        return loginDAO.chkUserCert(map);
    }
	public void updateUserCert(HashMap map) throws Exception {
        loginDAO.updateUserCert(map);
	}

}
