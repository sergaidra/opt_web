package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.GoodsManageService;
import kr.co.siione.mngr.service.TourClManageService;
import kr.co.siione.utl.ImageResizer;
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
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class GoodsManageController {
	
	protected Log log = LogFactory.getLog(this.getClass());
	
	private static final String ssUserId = "admin";

    @Inject
    MappingJackson2JsonView jsonView;

	@Resource(name = "GoodsManageService")
	private GoodsManageService goodsManageService;

	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;

	@Resource(name = "FileManageService")
	private FileManageService fileManageService;
	
	@RequestMapping(value="/mngr/GoodsManage/")
	public String GoodsManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/GoodsManage";
	}

	@RequestMapping(value="/mngr/GoodsRegist/")
	public String GoodsRegist(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		model.put("GOODS_CODE", UserUtils.nvl(param.get("GOODS_CODE")));
		return "/mngr/GoodsRegist";
	}

	@RequestMapping(value="/mngr/selectGoodsListForSearch/")
	public void selectGoodsListForSearch(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		log.debug("[selectGoodsListForSearch]param:"+param);

		try {
			results = goodsManageService.selectGoodsListForSearch(param);

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

	@RequestMapping(value="/mngr/insertGoods/")
	public void insertGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		param.put("WRITNG_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		//로그인 객체 선언
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//param.put("INQIRE_RESN", Util.convertText2Html(Util.nvl(param.get("INQIRE_RESN"))));

		try {
			UserUtils.log("[insertGoodsForBass]param", param);

			String sGoodsCode = goodsManageService.insertGoodsForBass(param);

			result.put("success", true);
			result.put("message", "(1)저장 성공");
			result.put("GOODS_CODE", sGoodsCode);
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/updateGoods/")
	public void updateGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		param.put("WRITNG_ID", ssUserId);
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();
		int iRe = 0;

		//로그인 객체 선언
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//param.put("INQIRE_RESN", Util.convertText2Html(Util.nvl(param.get("INQIRE_RESN"))));

		try {

			UserUtils.log("[updateGoods]param", param);
			String str = "";

			if(UserUtils.nvl(param.get("UPDT_SE")).equals("U")) {
				str = "기본정보";				
				iRe = goodsManageService.updateGoodsForBass(param);
			} else if(UserUtils.nvl(param.get("UPDT_SE")).equals("G")) {
				str = "이용안내";
				iRe = goodsManageService.updateGoodsForGuidance(param);
			} else if(UserUtils.nvl(param.get("UPDT_SE")).equals("E")) {
				str = "기타정보";
				iRe = goodsManageService.updateGoodsForEtc(param);
			} else {
				iRe = -9;
			}

			if(iRe > 0 ) {
				result.put("success", true);
				result.put("message", str+" 수정 성공");
			} else if(iRe == -9){
				result.put("success", false);
				result.put("message", "UPDT_SE("+UserUtils.nvl(param.get("UPDT_SE"))+") 전달 오류");
			} else {
				result.put("success", false);
				result.put("message", str+" 수정 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	
	@RequestMapping(value="/mngr/deleteGoods/")
	public void deleteGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		//로그인 객체 선언
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//param.put("INQIRE_RESN", Util.convertText2Html(Util.nvl(param.get("INQIRE_RESN"))));

		try {
			UserUtils.log("[deleteGoods]param", param);

			int iRe = goodsManageService.deleteGoods(param);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "삭제 성공");
			} else {
				result.put("success", false);
				result.put("message", "삭제 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/deleteGoodsMulti/")
	public void deleteGoodsMulti(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();

		//로그인 객체 선언
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//param.put("INQIRE_RESN", Util.convertText2Html(Util.nvl(param.get("INQIRE_RESN"))));
		
		try {
			UserUtils.log("[deleteGoodsMulti]param", param);
			
			
			String[] str = UserUtils.nvl(param.get("GOODS_CODE_LIST")).split(",");
			
			for(String aa : str) {
				System.out.println(">>  "+aa);
			}
			
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("GOODS_CODE_LIST", str);
			
			

			int iRe = goodsManageService.deleteGoodsMulti(map);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "삭제 성공");
			} else {
				result.put("success", false);
				result.put("message", "삭제 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectGoods/")
	public void selectGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		
		Map<String, String> results = new HashMap<String, String>();
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			results = goodsManageService.selectGoodsByPk(param);
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
	

	@RequestMapping(value="/mngr/saveGoodsSchdul/")
	public void saveGoodsSchdul(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		try {
			result = goodsManageService.saveGoodsSchdul(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsSchdul/")
	public void selectGoodsSchdul(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		log.debug("[selectGoodsSchdul]param:"+param);

		try {
			results = goodsManageService.selectGoodsSchdulList(param);

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

	@RequestMapping(value="/mngr/saveGoodsTime/")
	public void saveGoodsTime(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		UserUtils.log("[saveGoodsSchdul]param", param);

		try {
			result = goodsManageService.saveGoodsTime(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsTime/")
	public void selectGoodsTime(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		log.debug("[selectGoodsTimeList]param:"+param);

		try {
			results = goodsManageService.selectGoodsTimeList(param);

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

	@RequestMapping(value="/mngr/saveGoodsNmpr/")
	public void saveGoodsNmpr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		UserUtils.log("[saveGoodsNmpr]param", param);

		try {
			result = goodsManageService.saveGoodsNmpr(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsNmpr/")
	public void selectGoodsNmpr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		log.debug("[selectGoodsNmprList]param:"+param);

		try {
			results = goodsManageService.selectGoodsNmprList(param);

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

	@RequestMapping(value="/mngr/saveGoodsFile/")
	public void saveGoodsFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		UserUtils.log("[saveGoodsFile]param", param);

		try {
			result = goodsManageService.saveGoodsFile(param);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectGoodsFile/")
	public void selectGoodsFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		log.debug("[selectGoodsFileList]param:"+param);

		try {
			results = fileManageService.selectFileDetailList(param);

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

	@RequestMapping(value="/mngr/uploadGoodsFile/")
	public ModelAndView uploadGoodsFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		param.put("WRITNG_ID", ssUserId);

		//InputStream is = null;
		FileOutputStream fos = null;

		try {
			log.debug("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			log.debug("################File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			String fileName = file.getOriginalFilename();
			String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;

			String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "GOODS" + File.separator;
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

			goodsManageService.uploadGoodsFile(param);

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

	@RequestMapping(value="/mngr/uploadGoodsFiles/")
	public ModelAndView uploadGoodsFiles(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ModelAndView mav = new ModelAndView();

		param.put("WRITNG_ID", ssUserId);

		//InputStream is = null;
		FileOutputStream fos = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("param", param);
		
		// 파일 Param
		List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();

		try {
			log.debug("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			log.debug("################File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			//MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE");
			
			for(MultipartFile file : filelist) {
				String fileName = file.getOriginalFilename();
				String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;
				String resizeFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName.substring(0, fileName.lastIndexOf(".")) + "_resize" + fileName.substring(fileName.lastIndexOf("."));

				String storePath  = EgovProperties.getProperty("Globals.fileStorePath") + "GOODS" + File.separator;
				String resizePath = EgovProperties.getProperty("Globals.fileStorePath") + "GOODS" + File.separator + "thumb" + File.separator;
				File f = new File(storePath);
				if (!f.exists()) {
					f.mkdirs();
				}

				fos = new FileOutputStream(storePath + saveFileNm);
				fos.write(file.getBytes());
				

				// 상품 썸네일 이미지 저장
				int scaledWidth = 826/7;
				int scaledHeight = 428/7;
				ImageResizer.resize(storePath + saveFileNm, resizePath + resizeFileNm, scaledWidth, scaledHeight);
				
				Map<String, String> fileParam = new HashMap<String, String>();
				//param.put("REGIST_PATH", "상품");
				//param.put("FILE_SN", "1");
				fileParam.put("FILE_NM", fileName);
				fileParam.put("FILE_PATH", storePath + saveFileNm);
				fileParam.put("FILE_SIZE", String.valueOf(file.getSize()));
				fileParam.put("FILE_CL", ((file.getContentType().indexOf("image") > -1)?"I":"M")); // I:이미지, M:동영상
				fileParam.put("REPRSNT_AT", "N");
				fileParam.put("WRITNG_ID", ssUserId);
				//param.put("SORT_NO", "1");

				fileParamList.add(fileParam);
			}
			
			params.put("fileParamList", fileParamList);

			goodsManageService.uploadGoodsFileMulti(params);

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