package kr.co.siione.utl;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SessionCheck extends HandlerInterceptorAdapter {
	static final Logger log = LogManager.getLogger();

	/**
	 * 세션정보 체크
	 * 
	 * @param request
	 * @return
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		String uri = request.getServletPath();

		if(uri.contains("/mngr/")){
			//관리자
			ArrayList<String> freeAccessUrls = new ArrayList<String>();
			freeAccessUrls.add("/mngr/로그인필요한페이지/");
	
			if (freeAccessUrls.contains(uri)) {
				if (request.getSession().getAttribute("esntl_id") == null) {
					response.sendRedirect("/mngr/로그인페이지/");
					return false;
				} else {
					return true;
				}
			}
		}else{
			//일반사용자
			ArrayList<String> freeAccessUrls = new ArrayList<String>();
			
			/* json으로 활용되는 페이지는 별도로 처리 */
			//freeAccessUrls.add("/cart/addAction/");
			//freeAccessUrls.add("/cart/modAction/");
			
			freeAccessUrls.add("/cart/delAction/");
			freeAccessUrls.add("/cart/list/");
			freeAccessUrls.add("/cart/detail/");
			freeAccessUrls.add("/cart/schedulePopup/");
	
			if (freeAccessUrls.contains(uri)) {
				if (request.getSession().getAttribute("esntl_id") == null) {
					response.sendRedirect("/member/login/?result=need");
					return false;
				} else {
					return true;
				}
			}
		}
		return true;
	}


	public static String getUserIp(){
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}
	
	
}
