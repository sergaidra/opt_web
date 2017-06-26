package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.GoodsManageService;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class GoodsManageController {
	
	@Resource(name = "GoodsManageService")
	private GoodsManageService goodsManageService;
	
	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;
	
	@Resource(name = "FileManageService")
	private FileManageService fileManageService;
	
	private static final Logger LOG = LoggerFactory.getLogger(GoodsManageController.class);
	
	private static final String ssUserId = "admin";
	
	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : goodsManage
	 * 2. 설명 : 상품관리 화면 호출
	 * 3. 작성일 : 2017. 6. 1.
	 * </pre>
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/mngr/goodsManage/")
	public String goodsManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
    	try {
			List<Map<String, String>> list = goodsManageService.selectGoodsList(param);
			model.put("goodsList", list);
			
			List<Map<String, String>> listCl = tourClManageService.selectTourClList(param);
			model.put("tourClList", listCl);
		} catch (Exception e) {
			e.printStackTrace();
		}	
        return "/mngr/goodsManage";
	}
    
    @RequestMapping(value="/mngr/goodsRegist/")
	public String goodsRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/goodsRegist";	
	}    
    
    @RequestMapping(value="/mngr/goodsModify/")
	public String goodsModify(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			Map<String, String> map = goodsManageService.selectGoodsByPk(param);
			List<Map<String, String>> list = fileManageService.selectFileDetailList(param);
			model.put("goodsInfo", map);
			model.put("fileList", list);
			model.put("success", true);
		} catch (Exception e) {
			model.put("message", "상품 조회 중 오류가 발생했습니다.");
			model.put("success", false);
			e.printStackTrace();
		}	
        return "/mngr/goodsModify";	
	}    
    
    @RequestMapping(value="/mngr/addGoods/")
	public String addGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
    	Map<String, Object> result = new HashMap<String, Object>();
    	    	
		InputStream is = null;
		FileOutputStream fos = null;
    	
		try {
			LOG.debug("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			LOG.debug("################File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = getDate("yyyyMMddHHmmss") + "_" + fileName;
			
			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;
			File f = new File(storePath);
			if (!f.exists()) {
				f.mkdirs();
			}
		
			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());			
			
			param.put("REGIST_PATH", "상품");
			param.put("FILE_SN", "1");
			param.put("FILE_NM", fileName);
			param.put("FILE_PATH", storePath + saveFileNm);
			param.put("FILE_SIZE", String.valueOf(file.getSize()));
			param.put("FILE_CL", "I"); // I:이미지
			param.put("REPRSNT_AT", "Y");
			param.put("SORT_NO", "1");
			
			goodsManageService.insertGoods(param);
			
			result.put("message", "상품을 등록하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			result.put("message", "상품 등록 중 오류가 발생했습니다.");
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
		return "redirect:/mngr/goodsManage/";
    }
    
    @RequestMapping(value="/mngr/modGoods/")
	public String modGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
    	param.put("WRITNG_ID", ssUserId);
    	Map<String, Object> result = new HashMap<String, Object>();
    	
		InputStream is = null;
		FileOutputStream fos = null;
    	
		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("FILE_NM");
			String fileName = file.getOriginalFilename();
			String saveFileNm = getDate("yyyyMMddHHmmss") + "_" + fileName;
			
			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TOUR_CL" + File.separator;
			File f = new File(storePath);
			if (!f.exists()) {
				f.mkdirs();
			}
		
			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());			
			
			param.put("REGIST_PATH", "상품");
			param.put("FILE_SN", "1");
			param.put("FILE_NM", fileName);
			param.put("FILE_PATH", storePath + saveFileNm);
			param.put("FILE_SIZE", String.valueOf(file.getSize()));
			param.put("FILE_CL", "I"); // I:이미지
			param.put("REPRSNT_AT", "Y");
			param.put("SORT_NO", "1");

			goodsManageService.updateGoods(param);
			result.put("message", "상품을 수정하였습니다.");
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
		return "redirect:/mngr/goodsManage/";
	}  
    
    @RequestMapping(value="/mngr/delGoods/")
	public String delGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
    	param.put("UPDT_ID", ssUserId);
    	Map<String, Object> result = new HashMap<String, Object>();
    	
		try {
			if(goodsManageService.deleteGoods(param) > 0) {
				result.put("message", "상품을 삭제하였습니다.");
				result.put("success", true);	
			} else {
				result.put("message", "상품 삭제중 오류가 발생했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			result.put("message", e.getLocalizedMessage());
			result.put("success", false);
		}
		
		redirectAttr.addFlashAttribute("result", result);
		return "redirect:/mngr/goodsManage/";
	}
    
	public static String getDate(String sFormat) {
		SimpleDateFormat formatter = new SimpleDateFormat(sFormat, new Locale("ko", "KOREA"));
		return formatter.format(new Date());
	}
}