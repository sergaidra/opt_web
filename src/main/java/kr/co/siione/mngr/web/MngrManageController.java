package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.mngr.service.MngrManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class MngrManageController {
	
    @Inject
    MappingJackson2JsonView jsonView;
	
	@Resource(name = "MngrManageService")
	private MngrManageService mngrManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(MngrManageController.class);
	
	private static final String ssUserId = "admin";
	
    @RequestMapping(value={"/mngr/", "/mngr/index/"})
	public String mngrIndex(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/mngrIndex";	
	} 	
	
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
    @RequestMapping(value="/mngr/mngrManage/")
	public String mngrManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {

    	try {
		    //현재 페이지 파라메타
            String strPage = SimpleUtils.default_set(param.get("hidPage"));
            int intPage = 1;
    		if(!strPage.equals(""))		
    			intPage = Integer.parseInt((String)strPage);
			
			//페이지 기본설정
			int pageBlock = 10;
			int pageArea = 10;
			
			//page 
	    	PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(intPage);
			paginationInfo.setRecordCountPerPage(pageBlock);
			paginationInfo.setPageSize(pageArea);

			//HashMap<String, Integer> map = new HashMap<String, Integer>();
			param.put("startRow", String.valueOf(paginationInfo.getFirstRecordIndex()));
			param.put("endRow", String.valueOf(paginationInfo.getLastRecordIndex()));
	    				
			Map<String, ?> result = RequestContextUtils.getInputFlashMap(request);
			//FlashMap [attributes={result={message=가이드(관리자)를 등록하였습니다., success=true}}, targetRequestPath=/mngr/mngrManage/, targetRequestParams={}]
			
			List<Map<String, String>> list = mngrManageService.selectMngrList(param);
			
			if(list.size() > 0){
				int list_cnt = Integer.parseInt(String.valueOf(list.get(0).get("TOT_CNT")));
				paginationInfo.setTotalRecordCount(list_cnt);
			}
			model.put("paginationInfo", paginationInfo);
			
			model.put("mngrList", list);
			
			if(param!= null) {
				model.put("param", param);
			}
			if(result != null){
				model.put("message", result.get("message"));
				model.put("success", result.get("success"));
				model.put("param", result.get("param"));
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
	public String addMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
    	Map<String, Object> result = new HashMap<String, Object>();
    	result.put("param", param);
		try {
			mngrManageService.insertMngr(param);
			result.put("message", "가이드(관리자)를 등록하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}
		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/mngrManage/";
	}
    
    @RequestMapping(value="/mngr/modMngr/")
	public String modMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
    	param.put("UPDT_ID", ssUserId);
    	Map<String, Object> result = new HashMap<String, Object>();
    	result.put("param", param);    	
		try {
			if(mngrManageService.updateMngr(param) > 0) {
				result.put("message", "가이드(관리자)를 수정하였습니다.");
				result.put("success", true);	
			} else {
				result.put("message", "가이드(관리자) 수정 중 오류가 발생했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}
		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/mngrManage/";
	}  
    
    @RequestMapping(value="/mngr/delMngr/")
	public String delMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(mngrManageService.deleteMngr(param) > 0) {
				model.put("message", "가이드(관리자)를 삭제하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "가이드(관리자) 삭제 중 오류가 발생했습니다.");
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
    
    @RequestMapping(value="/mngr/confrmMngr/")
   	public String confrmMngr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
       	param.put("UPDT_ID", ssUserId);
       	Map<String, Object> result = new HashMap<String, Object>();
       	result.put("param", param);
   		try {
   			String sMsg = "승인처리";
   	       	if(!param.get("CONFM_AT").toString().equals("Y")){
   				sMsg = "승인취소처리";
   			}
   			if(mngrManageService.confrmMngr(param) > 0) {
  				result.put("message", sMsg+"하였습니다.");
   				result.put("success", true);	
   			} else {
   				result.put("message", sMsg+" 중 오류가 발생했습니다.");
   				result.put("success", false);
   			}
   		} catch (Exception e) {
   			result.put("message", e.getLocalizedMessage());
   			result.put("success", false);
   		}
   		redirectAttr.addFlashAttribute("result", result);
   		return "redirect:/mngr/mngrManage/";
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