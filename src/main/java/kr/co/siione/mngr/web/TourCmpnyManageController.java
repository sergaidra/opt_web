package kr.co.siione.mngr.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.TourCmpnyManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class TourCmpnyManageController {
	
	@Resource(name = "TourCmpnyManageService")
	private TourCmpnyManageService tourCmpnyManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(TourCmpnyManageController.class);
	
	private static final String ssUserId = "admin";
	
	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : tourCmpnyManage
	 * 2. 설명 : 여행사관리 화면 호출
	 * 3. 작성일 : 2017. 6. 1.
	 * </pre>
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/mngr/tourCmpnyManage/")
	public String tourCmpnyManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
			model.put("TOUR_CMPNY_LIST", list);
		} catch (Exception e) {
			e.printStackTrace();
		}	
        return "/mngr/tourCmpnyManage";	
	}
    
    @RequestMapping(value="/mngr/tourCmpnyPopup/")
	public String tourCmpnyPopup(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
			model.put("TOUR_CMPNY_LIST", list);
		} catch (Exception e) {
			e.printStackTrace();
		}	
        return "/mngr/tourCmpnyPopup";	
	}
    
    @RequestMapping(value="/mngr/tourCmpnyRegist/")
	public String tourCmpnyRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/tourCmpnyRegist";	
	}    
    
    @RequestMapping(value="/mngr/tourCmpnyModify/")
	public String tourCmpnyModify(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			Map<String, String> map = tourCmpnyManageService.selectTourCmpnyByPk(param);
			model.put("tourCmpnyInfo", map);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			e.printStackTrace();
		}	
        return "/mngr/tourCmpnyModify";	
	}    
    
    @RequestMapping(value="/mngr/addTourCmpny/")
	public String addTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
		try {
			tourCmpnyManageService.insertTourCmpny(param);
			model.put("message", "여행사를 등록하였습니다.");
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
		model.put("TOUR_CMPNY_LIST", list);

		return "/mngr/tourCmpnyManage";
	}
    
    @RequestMapping(value="/mngr/modTourCmpny/")
	public String modTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(tourCmpnyManageService.updateTourCmpny(param) > 0) {
				model.put("message", "여행사를 수정하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "여행사 수정중 오류가 발생했습니다.");
				model.put("success", false);
			}
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
		model.put("TOUR_CMPNY_LIST", list);
		
		return "/mngr/tourCmpnyManage";
	}  
    
    @RequestMapping(value="/mngr/delTourCmpny/")
	public String delTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(tourCmpnyManageService.deleteTourCmpny(param) > 0) {
				model.put("message", "여행사를 삭제하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "여행사 삭제중 오류가 발생했습니다.");
				model.put("success", false);
			}
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
		model.put("TOUR_CMPNY_LIST", list);
		
		return "/mngr/tourCmpnyManage";
	}    
}