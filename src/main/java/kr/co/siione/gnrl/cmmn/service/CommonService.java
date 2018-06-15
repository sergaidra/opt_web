package kr.co.siione.gnrl.cmmn.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface CommonService {
	public String getMessage(String msg, HttpServletRequest request);	
	
	public List<HashMap> getManagerUser(HashMap map) throws Exception;
	public void mailRequest(String request, String email) throws Exception;
	public void mailReply(String request, String answer, String email) throws Exception;
}
