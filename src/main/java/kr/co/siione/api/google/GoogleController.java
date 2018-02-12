package kr.co.siione.api.google;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.mngr.service.StplatManageService;
import kr.co.siione.utl.UserUtils;

import org.springframework.context.annotation.PropertySource;
import org.springframework.social.google.api.plus.Person;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping(value = "/api/google/")
@PropertySource("classpath:property/globals.properties")
public class GoogleController {

	@Resource
    private LoginService loginService;
	@Resource
	private StplatManageService stplatManageService;
	@Resource
    private GoogleService googleService;

    @RequestMapping(value="/loginCallback") 
    public String loginCallback(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	Person person = googleService.getPerson(request);

       	HashMap map = new HashMap();
       	String user_id = "";
       	for(String key : person.getEmails().keySet()) {
       		user_id = key;
       		break;
       	}
       	map.put("user_id", user_id);
       	HashMap result = loginService.userInfo(map);

       	if(result == null) {
       		System.out.println("google_person:"+person.getDisplayName()+"/"+person.getGivenName()+"/"+person.getFamilyName()+"/"+person.getGender()+"/");
       		String gender = "";
       		String google_name = UserUtils.nvl(person.getDisplayName()).trim();
       		if("male".equals(person.getGender()))
       			gender = "M";
       		if("female".equals(person.getGender()))
       			gender = "F";
       		
       		if("".equals(google_name)) {
       			google_name = (UserUtils.nvl(person.getGivenName()) + " " + UserUtils.nvl(person.getFamilyName())).trim();
       		}

       		model.addAttribute("joinMethod", "Google");
       		model.addAttribute("google_email", user_id);
       		model.addAttribute("google_gender", gender);       		
   			model.addAttribute("google_name", google_name);
        		
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
