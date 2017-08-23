package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.GoodsManageService;
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;

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
public class ExController {
    
	protected Log log = LogFactory.getLog(this.getClass());
	
	private static final String ssUserId = "admin";

    @Inject
    MappingJackson2JsonView jsonView;
    
	@Resource(name = "GoodsManageService")
	private GoodsManageService goodsManageService;
    
    @RequestMapping(value="/mngr/upload/")
	public String upload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/upload";	
	} 		
    
    @RequestMapping(value="/mngr/image/")
	public String image(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/mngr/image";	
	} 
    
	@RequestMapping(value="/mngr/uploadfiles/")
	public ModelAndView uploadfiles(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		param.put("WRITNG_ID", ssUserId);

		param.put("GOODS_CODE", "0000000062");
		
		
		UserUtils.log("[goods_file_multiple_upload]1)param", param);

		//InputStream is = null;
		FileOutputStream fos = null;

		try {
			log.debug("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			log.debug("################File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			//MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE");
			
			for(MultipartFile file : filelist) {
				
				String fileName = file.getOriginalFilename();
				String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;

				System.out.println("");
				log.debug("@@@@@@@@@@ fileName:"+fileName);
				log.debug("@@@@@@@@@@ saveFileNm:"+saveFileNm);
				
				
				String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "TEMP" + File.separator;
				File f = new File(storePath);
				if (!f.exists()) {
					f.mkdirs();
				}

				fos = new FileOutputStream(storePath + saveFileNm);
				fos.write(file.getBytes());

				//param.put("REGIST_PATH", "상품");
				//param.put("FILE_SN", "1");
				param.put("FILE_NM", fileName);
				param.put("FILE_PATH", storePath + saveFileNm);
				param.put("FILE_SIZE", String.valueOf(file.getSize()));
				param.put("FILE_CL", ((file.getContentType().indexOf("image") > -1)?"I":"M")); // I:이미지, M:동영상
				param.put("REPRSNT_AT", "N");
				//param.put("SORT_NO", "1");
				
				System.out.println("");
				UserUtils.log("[goods_file_multiple_upload]2)param", param);
				//goodsManageService.uploadGoodsFile(param);
			}
			
			mav.addObject("success", true);

		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();
			mav.addObject("success", false);
			mav.addObject("message", e.getMessage());
		} finally {
			try {
				//if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
				mav.addObject("success", false);
				mav.addObject("message", e.getMessage());
			}
		}

		log.debug("[goods_file_multiple_upload]3)mav:"+mav);
		mav.setViewName("jsonFileView");

		return mav;
	}

}