package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.mngr.service.TourCmpnyManageService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class TourCmpnyManageController {

	private static final String ssUserId = "admin";

	@Resource(name = "TourCmpnyManageService")
	private TourCmpnyManageService tourCmpnyManageService;

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
		if(param!= null) model.put("param", param);

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

			param.put("startRow", String.valueOf(paginationInfo.getFirstRecordIndex()));
			param.put("endRow", String.valueOf(paginationInfo.getLastRecordIndex()));

			List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
			model.put("tourCmpnyList", list);

			if(list.size() > 0){
				int list_cnt = Integer.parseInt(String.valueOf(list.get(0).get("TOT_CNT")));
				paginationInfo.setTotalRecordCount(list_cnt);
			}
			model.put("paginationInfo", paginationInfo);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "/mngr/bak/tourCmpnyManage";
	}

	@RequestMapping(value="/mngr/tourCmpnyPopup/")
	public String tourCmpnyPopup(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		if(param!= null) model.put("param", param);

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

			List<Map<String, String>> list = tourCmpnyManageService.selectTourCmpnyList(param);
			model.put("tourCmpnyList", list);

			if(list.size() > 0){
				int list_cnt = Integer.parseInt(String.valueOf(list.get(0).get("TOT_CNT")));
				paginationInfo.setTotalRecordCount(list_cnt);
			}
			model.put("paginationInfo", paginationInfo);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/mngr/bak/tourCmpnyPopup";
	}

	@RequestMapping(value="/mngr/tourCmpnyRegist/")
	public String tourCmpnyRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/bak/tourCmpnyRegist";
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
		return "/mngr/bak/tourCmpnyModify";
	}

	@RequestMapping(value="/mngr/addTourCmpny/")
	public String addTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("WRITNG_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			tourCmpnyManageService.insertTourCmpny(param);
			result.put("message", "여행사를 등록하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourCmpnyManage/";
	}

	@RequestMapping(value="/mngr/modTourCmpny/")
	public String modTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			if(tourCmpnyManageService.updateTourCmpny(param) > 0) {
				result.put("message", "여행사를 수정하였습니다.");
				result.put("success", true);
			} else {
				result.put("message", "여행사 수정 중 오류가 발생했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourCmpnyManage/";
	}

	@RequestMapping(value="/mngr/delTourCmpny/")
	public String delTourCmpny(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			if(tourCmpnyManageService.deleteTourCmpny(param) > 0) {
				result.put("message", "여행사를 삭제하였습니다.");
				result.put("success", true);
			} else {
				result.put("message", "여행사 삭제중 오류가 발생했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourCmpnyManage/";
	}
}