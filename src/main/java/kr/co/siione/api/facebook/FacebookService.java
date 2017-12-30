package kr.co.siione.api.facebook;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.social.ApiException;
import org.springframework.social.MissingAuthorizationException;
import org.springframework.social.connect.Connection;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.FacebookProfile;
import org.springframework.social.facebook.api.UserOperations;
import org.springframework.social.facebook.api.impl.FacebookTemplate;
import org.springframework.social.facebook.connect.FacebookConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Service;

@Service("FacebookService")
@PropertySource("classpath:property/globals.properties")
public class FacebookService {
	@Value("#{globals['facebook.client_id']}")
	private String facebook_client_id;

	@Value("#{globals['facebook.client_secret']}")
	private String facebook_client_secret;

	@Value("#{globals['facebook.login_redirect_uri']}")
	private String facebook_login_redirect_uri;


	public String initFacebookLogin(HttpServletRequest request) {
		String domain = request.getServerName();
		if(request.getServerPort() != 80)
			domain += ":" + String.valueOf(request.getServerPort());
		String redirect_url = String.format(facebook_login_redirect_uri, domain);

		FacebookConnectionFactory facebookConnectionFactory = new FacebookConnectionFactory(facebook_client_id, facebook_client_secret);
		OAuth2Parameters googleOAuth2Parameters = new OAuth2Parameters();
		googleOAuth2Parameters.add("scope", "public_profile");
		googleOAuth2Parameters.add("redirect_uri", redirect_url);
		OAuth2Operations oauthOperations = facebookConnectionFactory.getOAuthOperations();
		String facebook_url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, googleOAuth2Parameters);
		
		return facebook_url;
	}
	
	public FacebookProfile getProfile(HttpServletRequest request) {
    	String code = request.getParameter("code");		// code: 콜백으로 전달받은 인증 코드(authentication code). 접근 토큰(access token) 발급에 사용합니다.
		String domain = request.getServerName();
		if(request.getServerPort() != 80)
			domain += ":" + String.valueOf(request.getServerPort());
		String redirect_url = String.format(facebook_login_redirect_uri, domain);

		FacebookConnectionFactory facebookConnectionFactory = new FacebookConnectionFactory(facebook_client_id, facebook_client_secret);
		OAuth2Parameters googleOAuth2Parameters = new OAuth2Parameters();
		googleOAuth2Parameters.add("scope", "public_profile");
		googleOAuth2Parameters.add("redirect_uri", redirect_url);
    	OAuth2Operations oauthOperations = facebookConnectionFactory.getOAuthOperations(); 
    	AccessGrant accessGrant = oauthOperations.exchangeForAccess(code, googleOAuth2Parameters.getRedirectUri(), null); 
    	String accessToken = accessGrant.getAccessToken(); 
    	Long expireTime = accessGrant.getExpireTime(); 
    	if (expireTime != null && expireTime < System.currentTimeMillis()) { 
    		accessToken = accessGrant.getRefreshToken(); 
    		System.out.println(String.format("accessToken is expired. refresh token = %s" , accessToken));
    	} 
    	Connection<Facebook>connection = facebookConnectionFactory.createConnection(accessGrant); 
    	Facebook facebook = connection == null ? new FacebookTemplate(accessToken) : connection.getApi(); 
    	UserOperations userOperations = facebook.userOperations();
    	FacebookProfile facebookProfile = null;
    	try { 
    		facebookProfile = userOperations.getUserProfile(); 
    	} catch (MissingAuthorizationException e) { 
    		e.printStackTrace(); 
    	} catch (ApiException e) { 
    		e.printStackTrace(); 
    	}

    	return facebookProfile;
	}
}
