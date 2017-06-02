package kr.co.siione.mngr.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.TourClManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TourClManageController {
	
	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(TourClManageController.class);
	
	private static final String ssUserId = "admin";
	
	
    @RequestMapping(value="/mngr/index/")
	public String indexMngr(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/mngrIndex";	
	}
    
	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : tourClManage
	 * 2. 설명 : 여행분류관리 화면 호출
	 * 3. 작성일 : 2017. 6. 1.
	 * </pre>
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/mngr/tourClManage/")
	public String tourClManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/tourClManage";	
	}
    
      
}