package kr.co.siione.api.naver;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.mngr.service.StplatManageService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;


@Controller
@RequestMapping(value = "/api/naver/")
@PropertySource("classpath:property/globals.properties")
public class NaverController {

	@Resource
    private LoginService loginService;
	@Resource
	private StplatManageService stplatManageService;


	@Value("#{globals['naver.client_id']}")
	private String naver_client_id;

	@Value("#{globals['naver.client_secret']}")
	private String naver_client_secret;

    @RequestMapping(value="/loginCallback") 
    public String loginCallback(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	// CSRF 방지를 위한 상태 토큰 검증 검증
    	// 세션 또는 별도의 저장 공간에 저장된 상태 토큰과 콜백으로 전달받은 state 파라미터의 값이 일치해야 함

    	// 콜백 응답에서 state 파라미터의 값을 가져옴
    	String state = request.getParameter("state");	// state: 콜백으로 전달받은 상태 토큰. 애플리케이션이 생성한 상태 토큰과 일치해야 합니다.
    	String code = request.getParameter("code");		// code: 콜백으로 전달받은 인증 코드(authentication code). 접근 토큰(access token) 발급에 사용합니다.

    	// 세션 또는 별도의 저장 공간에서 상태 토큰을 가져옴
    	String storedState = (String)request.getSession().getAttribute("state");

    	if( !state.equals( storedState ) ) {
    	    return ""; //401 unauthorized
    	} else {
    		Map<String, String> mapToken = getAccessToken(state, code);
    		Map<String, String> mapProfile = getUserProfile(mapToken.get("token_type"), mapToken.get("access_token"));
    		
        	HashMap map = new HashMap();
        	map.put("user_id", mapProfile.get("email"));
        	HashMap result = loginService.userInfo(map);

        	if(result == null) {
        		model.addAttribute("joinMethod", "Naver");
        		model.addAttribute("naver_email", mapProfile.get("email"));
        		model.addAttribute("naver_gender", mapProfile.get("gender"));
        		model.addAttribute("naver_name", mapProfile.get("name"));
        		
        		Map<String, String> param = new HashMap<String, String>();
        		Map<String, String> result1 = new HashMap<String, String>();
        		Map<String, String> result2 = new HashMap<String, String>();
        		
        		param.put("STPLAT_CODE", "000001"); //이용약관
        		result1 = stplatManageService.selectStplatByPk(param);
        		param.put("STPLAT_CODE", "000003"); //개인정보취급방침
        		result2 = stplatManageService.selectStplatByPk(param);
                
                model.addAttribute("result1", result1.get("STPLAT_CN_HTML"));
                model.addAttribute("result2", result2.get("STPLAT_CN_HTML"));

        		return "gnrl/mber/join";
        	} else {
        		loginService.loginSuccess(request, response, result);
        	}
    	}
        
        return "gnrl/mber/login";
    }

    public Map<String, String> getUserProfile(String token_type, String access_token) {
    	Map<String, String> mapResult = new HashMap<String, String>();
        try {
            String apiURL = "https://openapi.naver.com/v1/nid/me";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("Authorization", token_type + " " + access_token);
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            System.out.println(response.toString());
            
            JSONParser parser = new JSONParser();
            JSONObject jsonObj = new JSONObject();
            try {
            	jsonObj = (JSONObject)parser.parse(response.toString());
            	String resultcode = (String)jsonObj.get("resultcode");
            	if("00".equals(resultcode)) {
            		JSONObject profile = (JSONObject)jsonObj.get("response");
            		String gender = (String)profile.get("gender");
            		String name = (String)profile.get("name");
            		String email = (String)profile.get("email");
            		String birthday = (String)profile.get("birthday");
            		
            		mapResult.put("gender", gender);
            		mapResult.put("name", name);
            		mapResult.put("email", email);
            		mapResult.put("birthday", birthday);
            	}
            } catch(ParseException e) {
            	e.printStackTrace();
            }
        } catch (Exception e) {
            System.out.println(e);
        }

        return mapResult;
    }
    
    public Map<String, String> getAccessToken(String state, String code) {
    	Map<String, String> mapResult = new HashMap<String, String>();
        try {
            String apiURL = String.format("https://nid.naver.com/oauth2.0/token?client_id=%s&client_secret=%s&grant_type=authorization_code&state=%s&code=%s"
            					, naver_client_id, naver_client_secret, state, code);
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            System.out.println(response.toString());
            
            JSONParser parser = new JSONParser();
            JSONObject jsonObj = new JSONObject();
            try {
            	jsonObj = (JSONObject)parser.parse(response.toString());
            	String access_token = (String)jsonObj.get("access_token");
            	String refresh_token = (String)jsonObj.get("refresh_token");
            	String token_type = (String)jsonObj.get("token_type");
            	String expires_in = (String)jsonObj.get("expires_in");
            	mapResult.put("access_token", access_token);
            	mapResult.put("token_type", token_type);
            } catch(ParseException e) {
            	e.printStackTrace();
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        
        return mapResult;
    }
}
