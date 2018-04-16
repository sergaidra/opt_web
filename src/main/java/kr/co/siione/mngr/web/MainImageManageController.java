package kr.co.siione.mngr.web;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.MainImageManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class MainImageManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "MainImageManageService")
	private MainImageManageService mainImageManageService;

	@Resource(name = "FileManageService")
	private FileManageService fileManageService;

	@Resource
	private UserUtils userUtils;

	@RequestMapping(value="/mngr/MainImageManage/")
	public String MainImageManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/MainImageManage";
	}

	@RequestMapping(value="/mngr/selectMainImageList/")
	public void selectMainImageList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			results = mainImageManageService.selectMainImageList(param);

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
	
	@RequestMapping(value="/mngr/insertMainImage/")
	public ModelAndView insertMainImage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("REGIST_ID", esntl_id);
		
		//InputStream is = null;
		FileOutputStream fos = null;
		HashMap<String, String> fileParam = new HashMap<String, String>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("ATTACH_FLIE");  // 파일 1개
			
			fileParam = userUtils.getFileInfo(file, "MAIN", true);
			fileParam.putAll(param);

			mainImageManageService.insertMainImage(fileParam);

			mav.addObject("success", true);

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
	
	
	@RequestMapping(value="/mngr/saveMainImage/")
	public void saveMainImage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

		try {
			result = mainImageManageService.saveMainImage(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}
	
		
	@RequestMapping(value="/mngr/uploadMainImages/")
	public ModelAndView uploadMainImages(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		//InputStream is = null;
		FileOutputStream fos = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		// 파일 Param
		List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE"); // 파일 1개 이상
			
			for(MultipartFile file : filelist) {
				Map<String, String> fileParam = userUtils.getFileInfo(file, "MAIN", true);
				fileParam.put("REGIST_ID", esntl_id);
				fileParamList.add(fileParam);
			}
			
			params.put("fileParamList", fileParamList);

			mainImageManageService.insertMainImageMulti(params);

			mav.addObject("success", true);

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
}