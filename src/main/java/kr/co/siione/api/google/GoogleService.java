package kr.co.siione.api.google;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.social.connect.Connection;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cmmn.service.ExcelService;
import kr.co.siione.gnrl.cmmn.service.FlightService;

@Service("GoogleService")
@PropertySource("classpath:property/globals.properties")
public class GoogleService {
	@Value("#{globals['google.client_id']}")
	private String google_client_id;

	@Value("#{globals['google.client_secret']}")
	private String google_client_secret;

	@Value("#{globals['google.login_redirect_uri']}")
	private String google_login_redirect_uri;


	public String initGoogleLogin(HttpServletRequest request) {
		String domain = request.getServerName();
		if(request.getServerPort() != 80)
			domain += ":" + String.valueOf(request.getServerPort());
		String redirect_url = String.format(google_login_redirect_uri, domain);

		GoogleConnectionFactory googleConnectionFactory = new GoogleConnectionFactory(google_client_id, google_client_secret);
		OAuth2Parameters googleOAuth2Parameters = new OAuth2Parameters();
		googleOAuth2Parameters.add("scope", "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/plus.profile.emails.read");
		googleOAuth2Parameters.add("redirect_uri", redirect_url);
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		String google_url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
		
		return google_url;
	}
	
	public Person getPerson(HttpServletRequest request) {
    	String code = request.getParameter("code");		// code: 콜백으로 전달받은 인증 코드(authentication code). 접근 토큰(access token) 발급에 사용합니다.
		String domain = request.getServerName();
		if(request.getServerPort() != 80)
			domain += ":" + String.valueOf(request.getServerPort());
		String redirect_url = String.format(google_login_redirect_uri, domain);

		GoogleConnectionFactory googleConnectionFactory = new GoogleConnectionFactory(google_client_id, google_client_secret);
		OAuth2Parameters googleOAuth2Parameters = new OAuth2Parameters();
		googleOAuth2Parameters.add("scope", "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/plus.profile.emails.read");
		googleOAuth2Parameters.add("redirect_uri", redirect_url);
    	OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations(); 
    	AccessGrant accessGrant = oauthOperations.exchangeForAccess(code, googleOAuth2Parameters.getRedirectUri(), null); 
    	String accessToken = accessGrant.getAccessToken(); 
    	Long expireTime = accessGrant.getExpireTime(); 
    	if (expireTime != null && expireTime < System.currentTimeMillis()) { 
    		accessToken = accessGrant.getRefreshToken(); 
    		System.out.println(String.format("accessToken is expired. refresh token = %s" , accessToken));
    	} 
    	Connection<Google>connection = googleConnectionFactory.createConnection(accessGrant); 
    	Google google = connection == null ? new GoogleTemplate(accessToken) : connection.getApi(); 
    	PlusOperations plusOperations = google.plusOperations(); 
    	return plusOperations.getGoogleProfile();
	}
}
