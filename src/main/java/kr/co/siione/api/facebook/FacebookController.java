package kr.co.siione.api.facebook;

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

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.social.connect.Connection;
import org.springframework.social.facebook.api.FacebookProfile;
import org.springframework.social.facebook.connect.FacebookServiceProvider;
import org.springframework.social.google.api.Google;
import org.springframework.social.google.api.impl.GoogleTemplate;
import org.springframework.social.google.api.plus.Person;
import org.springframework.social.google.api.plus.PlusOperations;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;


@Controller
@RequestMapping(value = "/api/facebook/")
@PropertySource("classpath:property/globals.properties")
public class FacebookController {

	@Resource
    private LoginService loginService;
	@Resource
	private StplatManageService stplatManageService;
	@Resource
    private FacebookService facebookService;

    @RequestMapping(value="/loginCallback") 
    public String loginCallback(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	FacebookProfile profile = facebookService.getProfile(request);

       	HashMap map = new HashMap();
       	String user_id = profile.getEmail();       	
       	map.put("user_id", user_id);
       	HashMap result = loginService.userInfo(map);

       	if(result == null) {
       		String gender = "";
       		//if("male".equals(person.getGender()))
       		//	gender = "M";
       		//if("female".equals(person.getGender()))
       		//	gender = "F";
       		model.addAttribute("joinMethod", "Google");
       		model.addAttribute("facebook_email", user_id);
       		model.addAttribute("facebook_gender", gender);       		
       		//model.addAttribute("facebook_name", person.getDisplayName());
        		
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
        
        return "gnrl/mber/login";
    }

}
