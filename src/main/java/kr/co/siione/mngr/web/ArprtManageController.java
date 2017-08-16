package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.ArprtManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class ArprtManageController {
	@Inject
    MappingJackson2JsonView jsonView;
	
	@Resource(name = "ArprtManageService")
	private ArprtManageService arprtManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(ArprtManageController.class);
	
	private static final String ssUserId = "admin";
	
    @RequestMapping(value="/mngr/ArprtManage/")
	public String ArprtManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/ArprtManage";
	}
    
    @RequestMapping(value="/mngr/selectArprtList/")
    public void selectArprtList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
    	List<Map<String,String>> results = null;

    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("REGIST_ID" , ssUserId);

		try {
			results = arprtManageService.selectArprtList(param);
		
			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
    }
    
    @RequestMapping(value="/mngr/saveArprtInfo/")
    public void saveTourClInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
    	Map<String, Object> result = new HashMap<String, Object>();

    	// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);
    	
    	try {
    		result = arprtManageService.saveArprtInfo(param);
    	} catch (Exception e) {
    		LOG.error(e.getMessage());
    		result.put("message", e.getMessage());
    		result.put("success", false);    		
    	}
    	
    	jsonView.render(result, request, response);
    } 
    

}