package kr.co.siione.utl;

import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
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
		
		/*

		ArrayList<String> u = new ArrayList<String>();

		u.add("/log/login.do");
		u.add("/log/logout.do");
		u.add("/log/loginRetry.do");



		if (!u.contains(uri)) {
			if (request.getSession().getAttribute("test") == null) {
				response.sendRedirect("/DIMS/log/loginRetry.do");
				return false;
			} else {
				return true;
			}
		}
		*/

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
