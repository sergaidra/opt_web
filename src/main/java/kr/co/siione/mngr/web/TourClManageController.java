package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.TourClManageService;
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class TourClManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	private static final String ssUserId = "admin";

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;

	@Resource(name = "FileManageService")
	private FileManageService fileManageService;

	@RequestMapping(value="/mngr/TourClUpperManage/")
	public String TourClUpperManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/TourClUpperManage";
	}

	@RequestMapping(value="/mngr/TourClManage/")
	public String TourClManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/TourClManage";
	}

	@RequestMapping(value="/mngr/selectTourClUpperList/")
	public void selectTourClUpperList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		try {
			results = tourClManageService.selectTourClUpperList(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}

	@RequestMapping(value="/mngr/selectTourClTree/")
	public void selectTourClTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		if(!param.containsKey("UPPER_CL_CODE")) {
			param.put("UPPER_CL_CODE", (String)param.get("node"));
		}

		try {
			results = tourClManageService.selectTourClTree(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}

	@RequestMapping(value="/mngr/saveTourClInfo/")
	public void saveTourClInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		try {
			result = tourClManageService.saveTourClInfo(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/uploadTourClFile/")
	public ModelAndView uploadTourClFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		param.put("WRITNG_ID", ssUserId);
		param.put("UPDT_ID", ssUserId);
		UserUtils.log("[file_upload_init]", param);

		//InputStream is = null;
		FileOutputStream fos = null;

		try {

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			String fileName = file.getOriginalFilename();
			String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;

			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;
			File f = new File(storePath);
			if (!f.exists()) {
				f.mkdirs();
			}

			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());

			param.put("REGIST_PATH", "여행분류");
			param.put("FILE_SN", "1");
			param.put("FILE_NM", fileName);
			param.put("FILE_PATH", storePath + saveFileNm);
			param.put("FILE_SIZE", String.valueOf(file.getSize()));
			param.put("FILE_CL", "I"); // I:이미지
			param.put("REPRSNT_AT", "Y");
			param.put("SORT_NO", "1");

			UserUtils.log("[file_upload]", param);
			int cnt = tourClManageService.uploadTourClFile(param);
			if(cnt > 0) {
				mav.addObject("success", true);
			} else {
				mav.addObject("success", false);
				mav.addObject("message", "저장 중 오류가 발생했습니다.");
			}
		} catch (Exception e) {
			log.error(e.getMessage());
			mav.addObject("success", false);
			mav.addObject("message", e.getMessage());
		} finally {
			try {
				//if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				log.error(e.getMessage());
				mav.addObject("success", false);
				mav.addObject("message", e.getMessage());
			}
		}

		mav.setViewName("jsonFileView");

		return mav;
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
	public String tourClManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			List<Map<String, String>> list = tourClManageService.selectTourClList(param);
			model.put("tourClList", list);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/mngr/bak/tourClManage";
	}

	@RequestMapping(value="/mngr/tourClRegist/")
	public String tourClRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/bak/tourClRegist";
	}

	@RequestMapping(value="/mngr/tourClModify/")
	public String tourClModify(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			Map<String, String> map = tourClManageService.selectTourClByPk(param);
			List<Map<String, String>> list = fileManageService.selectFileDetailList(param);
			model.put("tourClInfo", map);
			model.put("fileList", list);
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", "여행분류 조회 중 오류가 발생했습니다.");
			model.put("success", false);
			e.printStackTrace();
		}
		return "/mngr/bak/tourClModify";
	}

	@RequestMapping(value="/mngr/addTourCl/")
	public String addTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("WRITNG_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		InputStream is = null;
		FileOutputStream fos = null;

		try {

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;

			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;
			File f = new File(storePath);
			if (!f.exists()) {
				f.mkdirs();
			}

			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());

			param.put("REGIST_PATH", "여행분류");
			param.put("FILE_SN", "1");
			param.put("FILE_NM", fileName);
			param.put("FILE_PATH", storePath + saveFileNm);
			param.put("FILE_SIZE", String.valueOf(file.getSize()));
			param.put("FILE_CL", "I"); // I:이미지
			param.put("REPRSNT_AT", "Y");
			param.put("SORT_NO", "1");

			tourClManageService.insertTourCl(param);

			result.put("message", "여행분류를 등록하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			result.put("message", "여행분류 등록 중 오류가 발생했습니다.");
			result.put("success", false);
		} finally {
			try {
				if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				result.put("message", e.getLocalizedMessage());
				result.put("success", false);
			}
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourClManage/";
	}

	@RequestMapping(value="/mngr/modTourCl/")
	public String modTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("WRITNG_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		InputStream is = null;
		FileOutputStream fos = null;

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;

			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;
			File f = new File(storePath);
			if (!f.exists()) {
				f.mkdirs();
			}

			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());

			param.put("REGIST_PATH", "여행분류");
			param.put("FILE_SN", "1");
			param.put("FILE_NM", fileName);
			param.put("FILE_PATH", storePath + saveFileNm);
			param.put("FILE_SIZE", String.valueOf(file.getSize()));
			param.put("FILE_CL", "I"); // I:이미지
			param.put("REPRSNT_AT", "Y");
			param.put("SORT_NO", "1");

			tourClManageService.updateTourCl(param);
			result.put("message", "여행분류를 수정하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		} finally {
			try {
				if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				result.put("message", e.getLocalizedMessage());
				result.put("success", false);
			}
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourClManage/";
	}

	@RequestMapping(value="/mngr/delTourCl/")
	public String delTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			if(tourClManageService.deleteTourCl(param) > 0) {
				result.put("message", "여행분류를 삭제하였습니다.");
				result.put("success", true);
			} else {
				result.put("message", "여행분류 삭제중 오류가 발생했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}

		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/tourClManage/";
	}
}