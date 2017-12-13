package kr.co.siione.gnrl.mber.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.api.naver.NaverService;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.mngr.service.StplatManageService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.MailManager;
import kr.co.siione.utl.Sha256;
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;
import net.sf.json.JSONObject;

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


@Controller
@RequestMapping(value = "/member/")
@PropertySource("classpath:property/globals.properties")
public class LoginController {

	@Resource
    private LoginService loginService;
	@Resource
    private NaverService naverService;
	@Resource
	private StplatManageService stplatManageService;
		
	@Value("#{globals['naver.client_id']}")
	private String naver_client_id;

	@Value("#{globals['naver.login_redirect_uri']}")
	private String naver_login_redirect_uri;

    @RequestMapping(value="/login/")
    public String login(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));
        String user_nm = SimpleUtils.default_set((String)session.getAttribute("user_nm"));
        
        //model.addAttribute("user_id", user_id);
        //model.addAttribute("user_nm", user_nm);
        //model.addAttribute("userCnt", Integer.valueOf(loginManager.getUserCount()));
        String result = SimpleUtils.default_set(request.getParameter("result"));
        model.addAttribute("result", result);
        
        // 네이버 로그인을 위한 state 생성
        naverService.initNaverLogin(request);
        
        model.addAttribute("naver_client_id", naver_client_id);
        model.addAttribute("naver_login_redirect_uri", naver_login_redirect_uri);
        
        return "gnrl/mber/login";
    }

    @RequestMapping(value="/loginAction/")
    public void loginAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String user_id = SimpleUtils.default_set(request.getParameter("txtID"));
        String user_pw = SimpleUtils.default_set(request.getParameter("txtPW"));
        String adminYn = SimpleUtils.default_set(request.getParameter("adminYn"));

    	HashMap map = new HashMap();
    	map.put("user_id", user_id);
    	HashMap result = loginService.userInfo(map);

        if(result != null){
        	String esntl_id = (String) result.get("ESNTL_ID");
        	String password = (String) result.get("PASSWORD");
        	String crtfc_at = (String) result.get("CRTFC_AT");   
        	
        	user_pw = Sha256.encrypt(user_pw).toUpperCase();

        	//password
        	if(user_pw.equals(password)){
        		result.put("adminYn", adminYn);
        		loginService.loginSuccess(request, response, result);
        	}else{
                response.sendRedirect("/member/login/?result=fail");
        	}
        } else {
            response.sendRedirect("/member/login/?result=fail");
        }
    }    

    @RequestMapping(value="/logoutAction/")
    public void logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("/main/indexAction/");
    }

    @RequestMapping(value="/aliveJson/")
    public ResponseEntity sessionAlive(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        JSONObject obj = new JSONObject();
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/plain; charset=utf-8");
        HttpSession session = request.getSession();
        String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));

        if(user_id == null || user_id.isEmpty()){
            obj.put("RESULT", -1);
        }else{
            obj.put("RESULT", 0);
        }
        entity = new ResponseEntity(obj.toString(), responseHeaders, HttpStatus.CREATED);
        return entity;
    }

    @RequestMapping(value="/timerIframe/")
    public String sessionTimeout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/mber/timer";
    }
    

	
    @RequestMapping(value="/join")
    public String join(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "회원가입");
        model.addAttribute("mtitle", "");

		model.addAttribute("joinMethod", "Direct");
		
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
    }
	
	@RequestMapping(value="/chkUserInfo")
	public @ResponseBody ResponseVo chkUserInfo(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			String user_id = UserUtils.nvl(param.get("user_id"));

			HashMap map = new HashMap();	
			map.put("user_id", user_id);			

			UserUtils.log("[chkUserInfo-map]", map);
			
			int cnt = loginService.chkUserInfo(map);
			if(cnt > 0)
				resVo.setData("N");
			else
				resVo.setData("Y");
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/insertUser")
	public @ResponseBody ResponseVo insertUser(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			//String user_id = UserUtils.nvl(param.get("user_id"));
			String user_nm = UserUtils.nvl(param.get("user_nm"));
			String password = UserUtils.nvl(param.get("password"));
			String moblphon_no = UserUtils.nvl(param.get("moblphon_no"));
			String email = UserUtils.nvl(param.get("email"));
			String birth = UserUtils.nvl(param.get("birth"));
			String sex = UserUtils.nvl(param.get("sex"));
			String email_recptn_at = UserUtils.nvl(param.get("email_recptn_at"));
			String certkey = UUID.randomUUID().toString().replace("-", "");
			String joinMethod = UserUtils.nvl(param.get("joinMethod"));
			
			password = Sha256.encrypt(password).toUpperCase();

			HashMap map = new HashMap();	
			map.put("user_id", email);			
			map.put("user_nm", user_nm);			
			map.put("password", password);			
			map.put("moblphon_no", moblphon_no);			
			map.put("email", email);			
			map.put("birth", birth.replace("-", ""));			
			map.put("sex", sex);			
			map.put("email_recptn_at", email_recptn_at);
			map.put("certkey", certkey);
			map.put("esntl_id", loginService.getMaxEsntlId(map));
			
			if("Direct".equals(joinMethod)) {
				map.put("crtfc_at", "N");
			} else {
				map.put("crtfc_at", "Y");
			}

			UserUtils.log("[chkUserInfo-map]", map);
			
			int cnt = loginService.chkUserInfo(map);
			if(cnt > 0) {
				resVo.setResult("9");			
				resVo.setMessage("이미 가입되어있는 이메일입니다.");	
			} else {
				UserUtils.log("[insertUser-map]", map);
				
				loginService.insertUser(map);
				
				resVo.setResult("0");			
			}

		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

    @RequestMapping(value="/loginCert")
    public String loginCert(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String certkey = UserUtils.nvl(request.getParameter("key"));
        
		HashMap map = new HashMap();	
		map.put("certkey", certkey);		
		
		if(loginService.chkUserCert(map) > 0) {
			loginService.updateUserCert(map);
	        return "gnrl/mber/join_ok";
		} else {
	        return "gnrl/mber/join_fail";
		}
    }

    @RequestMapping(value="/idpw")
    public String idpw(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "비밀번호찾기");
        model.addAttribute("mtitle", "");

        return "gnrl/mber/idpw";
    }

	@RequestMapping(value="/searchPw")
	public @ResponseBody ResponseVo searchPw(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			String user_id = UserUtils.nvl(param.get("email"));
			String user_nm = UserUtils.nvl(param.get("user_nm"));

			HashMap map = new HashMap();	
			map.put("user_id", user_id);			
			map.put("user_nm", user_nm);			
			map.put("email", user_id);			

			UserUtils.log("[searchPw-map]", map);
			
			List<HashMap> lstMap = loginService.chkUserInfoPw(map);
			
			if(lstMap.size() == 0) {
				resVo.setResult("9");			
				resVo.setMessage("해당하는 정보가 없습니다.");
			} else {
				String certkey = String.valueOf(lstMap.get(0).get("CERTKEY"));
				if("".equals(certkey)) {
					certkey = UUID.randomUUID().toString().replace("-", "");
					map.put("certkey", certkey);	
					loginService.updateCertKey(map);
				}
				map.put("certkey", certkey);	
				
				loginService.sendPwSearchEmail(map);
				resVo.setResult("0");			
			}
			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
    @RequestMapping(value="/pwsetup")
    public String pwsearch(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String certkey = UserUtils.nvl(request.getParameter("key"));
		
        model.addAttribute("certkey", certkey);
        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "비밀번호 재설정");
        model.addAttribute("mtitle", "");

        return "gnrl/mber/pwsetup";
    }
    
	@RequestMapping(value="/changePw")
	public @ResponseBody ResponseVo changePw(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			String certkey = UserUtils.nvl(param.get("certkey"));
			String password = UserUtils.nvl(param.get("password"));
			password = Sha256.encrypt(password).toUpperCase();
			
			HashMap map = new HashMap();	
			map.put("certkey", certkey);			
			map.put("password", password);			
			
			UserUtils.log("[changePw-map]", map);
			loginService.updatePassword(map);
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

}
