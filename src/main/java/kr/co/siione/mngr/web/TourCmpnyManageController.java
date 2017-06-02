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
	public String tourCmpnyManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap map) throws Exception {
		try {
			List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
			map.put("TOUR_CMPNY_LIST", list);
		} catch (Exception e) {
			e.printStackTrace();
		}	
        return "/mngr/tourCmpnyManage";	
	}
    
      
}