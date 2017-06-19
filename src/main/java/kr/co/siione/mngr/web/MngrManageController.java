package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.MngrManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class MngrManageController {
	
    @Inject
    MappingJackson2JsonView jsonView;
	
	@Resource(name = "MngrManageService")
	private MngrManageService mngrManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(MngrManageController.class);
	
	private static final String ssUserId = "admin";
	
	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : mngrManage
	 * 2. 설명 : 관리자관리 화면 호출
	 * 3. 작성일 : 2017. 6. 1.
	 * </pre>
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value={"/mngr/mngrManage/", "/mngr/getMngrList/"})
	public String mngrManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			System.out.println(param);
			List<Map<String, String>> list = mngrManageService.selectMngrList(param);
			model.put("mngrList", list);
			if(param!= null) {
				model.put("param", param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
        return "/mngr/mngrManage";	
	}
    
    @RequestMapping(value="/mngr/mngrRegist/")
	public String mngrRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/mngrRegist";	
	}    
    
    @RequestMapping(value="/mngr/mngrModify/")
	public String mngrModify(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			Map<String, String> map = mngrManageService.selectMngrByPk(param);
			model.put("mngrInfo", map);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			e.printStackTrace();
		}	
        return "/mngr/mngrModify";	
	}    
    
    @RequestMapping(value="/mngr/addMngr/")
	public String addMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
		try {
			mngrManageService.insertMngr(param);
			model.put("message", "여행사를 등록하였습니다.");
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = mngrManageService.selectMngrList(param);
		model.put("mngrList", list);

		return "/mngr/mngrManage";
	}
    
    @RequestMapping(value="/mngr/modMngr/")
	public String modMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(mngrManageService.updateMngr(param) > 0) {
				model.put("message", "여행사를 수정하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "여행사 수정 중 오류가 발생했습니다.");
				model.put("success", false);
			}
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = mngrManageService.selectMngrList(param);
		model.put("mngrList", list);
		
		return "/mngr/mngrManage";
	}  
    
    @RequestMapping(value="/mngr/delMngr/")
	public String delMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(mngrManageService.deleteMngr(param) > 0) {
				model.put("message", "여행사를 삭제하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "여행사 삭제 중 오류가 발생했습니다.");
				model.put("success", false);
			}
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = mngrManageService.selectMngrList(param);
		model.put("mngrList", list);
		
		return "/mngr/mngrManage";
	}    
    
    @RequestMapping(value="/mngr/getMngrListAjax/")
	public void getMngrListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
    	Map<String, Object> result = new HashMap<String, Object>();
    	try {
			List<Map<String, String>> list = mngrManageService.selectMngrList(param);
			result.put("rows", list.size());
			result.put("mngrList", list);
			result.put("message", "성공");
			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("message", "실패");
			result.put("success", false);
		}	
		jsonView.render(result, request, response);
	}    
    
       
       
}