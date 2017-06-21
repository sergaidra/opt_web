package kr.co.siione.gnrl.mber.service;

import java.util.HashMap;

public interface LoginService {
    public HashMap userInfo(HashMap map) throws Exception;
    public void userLog(HashMap map) throws Exception;
    public void joinMeber(HashMap map) throws Exception;
}
