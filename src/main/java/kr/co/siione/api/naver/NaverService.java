package kr.co.siione.api.naver;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cmmn.service.ExcelService;
import kr.co.siione.gnrl.cmmn.service.FlightService;

@Service("NaverService")
public class NaverService {

	// CSRF 방지를 위한 상태 토큰 생성 코드
	// 상태 토큰은 추후 검증을 위해 세션에 저장되어야 한다.
	public String generateState()
	{
	    SecureRandom random = new SecureRandom();
	    return new BigInteger(130, random).toString(32);
	}

	public void initNaverLogin(HttpServletRequest request) {
		// 상태 토큰으로 사용할 랜덤 문자열 생성
		String state = generateState();
		// 세션 또는 별도의 저장 공간에 상태 토큰을 저장
		request.getSession().setAttribute("state", state);
	}
}
