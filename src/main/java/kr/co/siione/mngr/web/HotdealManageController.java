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

import kr.co.siione.mngr.service.HotdealManageService;
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
public class HotdealManageController {
	
	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "HotdealManageService")
	private HotdealManageService hotdealManageService;

	@RequestMapping(value="/mngr/HotdealManage/")
	public String HotdealManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/HotdealManage";
	}
		
	@RequestMapping(value="/mngr/selectHotdealList/")
	public void selectHotdealList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			results = hotdealManageService.selectHotdealList(param);
		
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
	
	@RequestMapping(value="/mngr/selectHotdealInfo/")
	public void selectHotdealInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		//List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, String> results = new HashMap<String, String>();
		
		try {
			results = hotdealManageService.selectHotdealByPk(param);
		
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
	
	@RequestMapping(value="/mngr/insertHotdeal/")
	public ModelAndView insertHotdeal(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("REGIST_ID", esntl_id);
		param.put("WRITNG_ID", esntl_id);

		//InputStream is = null;
		FileOutputStream fos = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("param", param);
		
		// 파일 Param
		List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			
			MultipartFile file = mRequest.getFile("ATTACH_FLIE_L");
			Map<String, String> fileParam = new HashMap<String, String>();
			fileParam = UserUtils.getFileInfo(file, "HOTDEAL", false);
			fileParam.put("FILE_SN", "1");
			fileParam.put("SORT_ORDR", "1");
			fileParam.put("REPRSNT_AT", "N");
			fileParam.put("WRITNG_ID", esntl_id);
			fileParamList.add(fileParam);
				
			MultipartFile file2 = mRequest.getFile("ATTACH_FLIE_S");
			Map<String, String> fileParam2 = new HashMap<String, String>();
			fileParam2 = UserUtils.getFileInfo(file2, "HOTDEAL", false);
			fileParam2.put("FILE_SN", "1");
			fileParam2.put("SORT_ORDR", "1");
			fileParam2.put("REPRSNT_AT", "N");
			fileParam2.put("WRITNG_ID", esntl_id);
			fileParamList.add(fileParam2);
			
			params.put("fileParamList", fileParamList);

			hotdealManageService.insertHotdeal(params);

			mav.addObject("success", true);
			mav.addObject("message", "저장하였습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			mav.addObject("success", false);
			mav.addObject("message", e.getMessage());
		} finally {
			try {
				//if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				e.printStackTrace();
				log.error(e.getMessage());
				mav.addObject("success", false);
				mav.addObject("message", e.getMessage());
			}
		}

		mav.setViewName("jsonFileView");

		return mav;
	}
	
	@RequestMapping(value="/mngr/updateHotdeal/")
	public ModelAndView updateHotdeal(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("UPDT_ID", esntl_id);

		//InputStream is = null;
		FileOutputStream fos = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("param", param);
		
		// 파일 Param
		List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			
			MultipartFile file = mRequest.getFile("ATTACH_FLIE_L");
			if(!UserUtils.nvl(file.getOriginalFilename()).equals("")) {
				Map<String, String> fileParam = new HashMap<String, String>();
				fileParam = UserUtils.getFileInfo(file, "HOTDEAL", false);
				fileParam.put("FILE_CODE", (String)param.get("FILE_CODE_L"));
				fileParam.put("FILE_SN", "1");
				fileParam.put("SORT_ORDR", "1");
				fileParam.put("REPRSNT_AT", "N");
				fileParam.put("WRITNG_ID", esntl_id);
				fileParamList.add(fileParam);	
			}
				
			MultipartFile file2 = mRequest.getFile("ATTACH_FLIE_S");
			if(!UserUtils.nvl(file2.getOriginalFilename()).equals("")) {
				Map<String, String> fileParam2 = new HashMap<String, String>();
				fileParam2 = UserUtils.getFileInfo(file2, "HOTDEAL", false);
				fileParam2.put("FILE_CODE", (String)param.get("FILE_CODE_S"));
				fileParam2.put("FILE_SN", "1");
				fileParam2.put("SORT_ORDR", "1");
				fileParam2.put("REPRSNT_AT", "N");
				fileParam2.put("WRITNG_ID", esntl_id);
				fileParamList.add(fileParam2);
			}
			
			params.put("fileParamList", fileParamList);

			hotdealManageService.updateHotdeal(params);

			mav.addObject("success", true);
			mav.addObject("message", "저장하였습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			mav.addObject("success", false);
			mav.addObject("message", e.getMessage());
		} finally {
			try {
				//if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				e.printStackTrace();
				log.error(e.getMessage());
				mav.addObject("success", false);
				mav.addObject("message", e.getMessage());
			}
		}

		mav.setViewName("jsonFileView");

		return mav;
	}	
}