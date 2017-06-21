package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.TourClManageService;
import kr.co.siione.utl.egov.EgovProperties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class TourClManageController {
	
	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;
	
	@Resource(name = "FileManageService")
	private FileManageService fileManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(TourClManageController.class);
	
	private static final String ssUserId = "admin";
	
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
        return "/mngr/tourClManage";	
	}
    
    @RequestMapping(value="/mngr/tourClRegist/")
	public String tourClRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/tourClRegist";	
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
        return "/mngr/tourClModify";	
	}    
    
    @RequestMapping(value="/mngr/addTourCl/")
	public String addTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
    	
    	MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
    	
		InputStream is = null;
		FileOutputStream fos = null;
    	
		try {
			
			System.out.println("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			System.out.println("################File.separator:"+File.separator);
			
			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;

			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = getDate("yyyyMMddHHmmss") + "_" + fileName;
			
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
			
			model.put("message", "여행분류를 등록하였습니다.");
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", "여행분류 등록 중 오류가 발생했습니다.");
			model.put("success", false);
		} finally {
    		try {
	    		if (is != null) is.close();
	    		if (fos != null) fos.close();
    		} catch (Exception e) {
    			model.put("message", e.getLocalizedMessage());
    			model.put("success", false);
    		}
		}

		List<Map<String, String>> list = tourClManageService.selectTourClList(param);
		model.put("tourClList", list);
		
		return "/mngr/tourClManage";
    }
    
    @RequestMapping(value="/mngr/modTourCl/")
	public String modTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
		
    	MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
    	
		InputStream is = null;
		FileOutputStream fos = null;
    	
		try {
			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;

			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = getDate("yyyyMMddHHmmss") + "_" + fileName;
						
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
			model.put("message", "여행분류를 수정하였습니다.");
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		} finally {
    		try {
	    		if (is != null) is.close();
	    		if (fos != null) fos.close();
    		} catch (Exception e) {
    			model.put("message", e.getLocalizedMessage());
    			model.put("success", false);
    		}
		}

		List<Map<String, String>> list = tourClManageService.selectTourClList(param);
		model.put("tourClList", list);
		
		return "/mngr/tourClManage";
	}  
    
    @RequestMapping(value="/mngr/delTourCl/")
	public String delTourCl(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	param.put("UPDT_ID", ssUserId);
		try {
			if(tourClManageService.deleteTourCl(param) > 0) {
				model.put("message", "여행분류를 삭제하였습니다.");
				model.put("success", true);	
			} else {
				model.put("message", "여행분류 삭제중 오류가 발생했습니다.");
				model.put("success", false);
			}
		} catch (Exception e) {
			model.put("message", e.getLocalizedMessage());
			model.put("success", false);
		}
		List<Map<String, String>> list = tourClManageService.selectTourClList(param);
		model.put("tourClList", list);
		
		return "/mngr/tourClManage";
	}
    
	public static String getDate(String sFormat) {
		SimpleDateFormat formatter = new SimpleDateFormat(sFormat, new Locale("ko", "KOREA"));
		return formatter.format(new Date());
	}
}