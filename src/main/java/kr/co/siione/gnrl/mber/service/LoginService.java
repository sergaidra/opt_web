package kr.co.siione.gnrl.mber.service;

import java.util.HashMap;

public interface LoginService {
    public HashMap userInfo(HashMap hashmap) throws Exception;
    public void userLog(HashMap hashmap) throws Exception;
    public void joinMeber(HashMap hashmap) throws Exception;
}
