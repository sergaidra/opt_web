package kr.co.siione.gnrl.mber.service;

import java.util.HashMap;
import java.util.List;

public interface LoginService {
    public HashMap userInfo(HashMap map) throws Exception;
    public void userLog(HashMap map) throws Exception;
    public int chkUserInfo(HashMap map) throws Exception;
    public String getMaxEsntlId(HashMap map) throws Exception;
	public void insertUser(HashMap map) throws Exception;
    public int chkUserCert(HashMap map) throws Exception;
    public void updateUserCert(HashMap map) throws Exception;
    
    public List<HashMap> chkUserInfoPw(HashMap map) throws Exception;
    public void updateCertKey(HashMap map) throws Exception;
    public void updatePassword(HashMap map) throws Exception;
    public void sendPwSearchEmail(HashMap map) throws Exception;
}
