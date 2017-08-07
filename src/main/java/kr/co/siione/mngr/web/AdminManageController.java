package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.AdminManageService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class AdminManageController {
    
	protected Log log = LogFactory.getLog(this.getClass());
	
	private static final String ssUserId = "admin";
	
    @Inject
    MappingJackson2JsonView jsonView;
    
	@Resource(name = "adminManageService")
	private AdminManageService adminManageService;
    
    @RequestMapping(value={"/mngr/index/"})
	public String mngrIndex(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/bak/mngrIndex";	
	} 	
    
    @RequestMapping(value={"/mngr/", "/mngr/main/"})
	public String mngrMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/MngrMain";	
	} 	
    
    @RequestMapping(value="/mngr/selectMenuTree/")
    public void selectMenuTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	try {
    		List<Map<String,Object>> results = adminManageService.selectMenuTree(param);
    		
    		result.put("rows", results.size());
    		result.put("data", results);
    	} catch (Exception e) {
    		log.error(e.getLocalizedMessage());
    		result.put("success", false);
    		result.put("message", e.getLocalizedMessage());
    	}
    	
    	jsonView.render(result, request, response);
    }

}