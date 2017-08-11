package kr.co.siione.mngr.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
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
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
public class GoodsManageController {
	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "GoodsManageService")
	private GoodsManageService goodsManageService;

	@Resource(name = "TourClManageService")
	private TourClManageService tourClManageService;

	@Resource(name = "FileManageService")
	private FileManageService fileManageService;

	private static final Logger LOG = LoggerFactory.getLogger(GoodsManageController.class);

	private static final String ssUserId = "admin";

	@RequestMapping(value="/mngr/GoodsManage/")
	public String GoodsManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/GoodsManage";
	}

	@RequestMapping(value="/mngr/GoodsRegist/")
	public String GoodsRegist(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/GoodsRegist";
	}

	@RequestMapping(value="/mngr/selectGoodsListForSearch/")
	public void selectGoodsListForSearch(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		// TODO 로그인 사용자 정보
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		param.put("USER_ID" , ssUserId);

		LOG.debug("[selectGoodsListForSearch]param:"+param);

		try {
			results = goodsManageService.selectGoodsListForSearch(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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

			if(UserUtils.nvl(param.get("UPDT_SE")).equals("U")) {
				iRe = goodsManageService.updateGoodsForBass(param);
			} else if(UserUtils.nvl(param.get("UPDT_SE")).equals("G")) {
				iRe = goodsManageService.updateGoodsForGuidance(param);
			} else if(UserUtils.nvl(param.get("UPDT_SE")).equals("E")) {
				iRe = goodsManageService.updateGoodsForEtc(param);
			} else {
				iRe = -9;
			}

			if(iRe > 0 ) {
				result.put("success", true);
				result.put("message", "(2)수정 성공");
			} else if(iRe == -9){
				result.put("success", false);
				result.put("message", "(2)UPDT_SE 전달 오류");
			} else {
				result.put("success", false);
				result.put("message", "(2)수정 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("message"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectGoods/")
	public void selectGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		

		Map<String, String> results = new HashMap<String, String>();
		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("[selectGoods]param:"+param);

		try {
			results = goodsManageService.selectGoodsByPk(param);
			
			
			UserUtils.log("[selectGoods]result", results);
			
			
			

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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
			LOG.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsSchdul/")
	public void selectGoodsSchdul(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("[selectGoodsSchdul]param:"+param);

		try {
			results = goodsManageService.selectGoodsSchdulList(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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
			LOG.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsTime/")
	public void selectGoodsTime(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("[selectGoodsTimeList]param:"+param);

		try {
			results = goodsManageService.selectGoodsTimeList(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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
			LOG.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}

	@RequestMapping(value="/mngr/selectGoodsNmpr/")
	public void selectGoodsNmpr(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("[selectGoodsNmprList]param:"+param);

		try {
			results = goodsManageService.selectGoodsNmprList(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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
			LOG.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		}

		jsonView.render(result, request, response);
	}
	
	@RequestMapping(value="/mngr/selectGoodsFile/")
	public void selectGoodsFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		LOG.debug("[selectGoodsFileList]param:"+param);

		try {
			results = fileManageService.selectFileDetailList(param);

			result.put("rows", results.size());
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getMessage());
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

		UserUtils.log("[goods_file_upload]1)param", param);

		//InputStream is = null;
		FileOutputStream fos = null;

		try {
			LOG.debug("################Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			LOG.debug("################File.separator:"+File.separator);

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

			UserUtils.log("[goods_file_upload]2)param", param);
			goodsManageService.uploadGoodsFile(param);

			mav.addObject("success", true);

		} catch (Exception e) {
			LOG.error(e.getMessage());
			mav.addObject("success", false);
			mav.addObject("message", e.getMessage());
		} finally {
			try {
				//if (is != null) is.close();
				if (fos != null) fos.close();
			} catch (Exception e) {
				LOG.error(e.getMessage());
				mav.addObject("success", false);
				mav.addObject("message", e.getMessage());
			}
		}

		LOG.debug("[goods_file_upload]3)mav:"+mav);
		mav.setViewName("jsonFileView");

		return mav;
	}


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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/mngr/bak/goodsManage";
	}

	@RequestMapping(value="/mngr/goodsRegist/")
	public String goodsRegist(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			param.put("DELETE_AT","N");
			List<Map<String, String>> listCl = tourClManageService.selectTourClList(param);
			model.put("tourClList", listCl);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/mngr/bak/goodsRegist";
	}

	@RequestMapping(value="/mngr/goodsModify/")
	public String goodsModify(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			param.put("DELETE_AT","N");
			List<Map<String, String>> listCl = tourClManageService.selectTourClList(param);
			model.put("tourClList", listCl);

			Map<String, String> map = goodsManageService.selectGoodsByPk(param);
			List<Map<String, String>> list = fileManageService.selectFileDetailList(param);
			List<Map<String, String>> clList = goodsManageService.selectGoodsClList(param);
			List<Map<String, String>> mngrList = goodsManageService.selectGoodsNmprList(param);
			List<Map<String, String>> timeList = goodsManageService.selectGoodsTimeList(param);
			List<Map<String, String>> schdulList = goodsManageService.selectGoodsSchdulList(param);

			model.put("goodsInfo", map);
			model.put("fileList", list);
			model.put("clList", clList);
			model.put("mngrList", mngrList);
			model.put("timeList", timeList);
			model.put("schdulList", schdulList);

			model.put("success", true);
		} catch (Exception e) {
			model.put("message", "상품 조회 중 오류가 발생했습니다.");
			model.put("success", false);
			e.printStackTrace();
		}

		return "/mngr/bak/goodsModify";
	}

	@RequestMapping(value="/mngr/addGoods/")
	public String addGoods(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, RedirectAttributes redirectAttr) throws Exception {
		param.put("WRITNG_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();

		InputStream is = null;
		FileOutputStream fos = null;

		UserUtils.log("[상품등록]", param);

		try {
			// 상품 분류
			String clCode[] = request.getParameterValues("CL_CODE");

			// 상품 일정
			String beginDe[] = request.getParameterValues("BEGIN_DE");
			String endDe[] = request.getParameterValues("END_DE");
			String mon[] = UserUtils.nvl(param.get("txtMon")).split(";");
			String tue[] = UserUtils.nvl(param.get("txtTue")).split(";");
			String wed[] = UserUtils.nvl(param.get("txtWed")).split(";");
			String thu[] = UserUtils.nvl(param.get("txtThu")).split(";");
			String fri[] = UserUtils.nvl(param.get("txtFri")).split(";");
			String sat[] = UserUtils.nvl(param.get("txtSat")).split(";");
			String sun[] = UserUtils.nvl(param.get("txtSun")).split(";");

			// 상품 시간
			String beginHh[] = request.getParameterValues("BEGIN_HH");
			String beginMi[] = request.getParameterValues("BEGIN_MI");
			String endHh[] = request.getParameterValues("END_HH");
			String endMi[] = request.getParameterValues("END_MI");

			// 상품 인원
			String nmprCnd[] = request.getParameterValues("NMPR_CND");
			String setupAmount[] = request.getParameterValues("SETUP_AMOUNT");

			LOG.debug("################ Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			LOG.debug("################ File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			LOG.debug("@@@@@@@@@@@@@@@@@@ mRequest:"+mRequest);

			List<MultipartFile> filelist = mRequest.getFiles("FILE_NM");
			//MultipartFile file = mRequest.getFile("FILE_NM");
			LOG.debug("#################### 파일수:"+filelist.size());

			// 파일 Param
			List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();
			int fileSn = 0;
			for(MultipartFile file : filelist) {
				String fileName = file.getOriginalFilename();
				LOG.debug("#################### 파일이름:"+fileName);
				if(!fileName.equals("")) {
					fileSn++;
					String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;
					LOG.debug("$$$$$$$$$$$$$$$$$$$$ 저장파일이름:"+saveFileNm);
					LOG.debug("$$$$$$$$$$$$$$$$$$$$ getContentType:"+file.getContentType());

					String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "GOODS" + File.separator;
					File f = new File(storePath);
					if (!f.exists()) {
						f.mkdirs();
					}

					fos = new FileOutputStream(storePath + saveFileNm);
					fos.write(file.getBytes());

					Map<String, String> fileParam = new HashMap<String, String>();
					fileParam.put("REGIST_PATH", "상품");
					fileParam.put("FILE_SN", String.valueOf(fileSn)); // TODO
					fileParam.put("FILE_NM", fileName);
					fileParam.put("FILE_PATH", storePath + saveFileNm);
					fileParam.put("FILE_SIZE", String.valueOf(file.getSize()));
					fileParam.put("FILE_CL", ((file.getContentType().indexOf("image") > -1)?"I":"M")); // I:이미지, M:동영상
					fileParam.put("REPRSNT_AT", (fileSn==1?"Y":"N"));
					fileParam.put("SORT_NO", String.valueOf(fileSn)); // TODO
					fileParam.put("WRITNG_ID", param.get("WRITNG_ID"));

					LOG.debug("[fileParam]"+fileSn+")"+fileParam);

					fileParamList.add(fileParam);
				}
			}
			params.put("fileParamList", fileParamList);

			// 상품 Param
			params.put("goodsParam", param);

			// 상품 분류 Param
			List<Map<String, String>> clParamList = new ArrayList<Map<String, String>>();
			for(String str : clCode) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("CL_CODE", str);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				clParamList.add(map);
			}
			params.put("clParamList", clParamList);

			// 상품 일정 Param
			List<Map<String, String>> schdulParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < beginDe.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("BEGIN_DE", beginDe[i]);
				map.put("END_DE", endDe[i]);
				map.put("MONDAY_POSBL_AT", mon[i]);
				map.put("TUSDAY_POSBL_AT", tue[i]);
				map.put("WDNSDY_POSBL_AT", wed[i]);
				map.put("THRSDAY_POSBL_AT", thu[i]);
				map.put("FRIDAY_POSBL_AT", fri[i]);
				map.put("SATDAY_POSBL_AT", sat[i]);
				map.put("SUNDAY_POSBL_AT", sun[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				schdulParamList.add(map);
			}
			params.put("schdulParamList", schdulParamList);

			// 상품 시간 Param
			List<Map<String, String>> timeParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < beginHh.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("BEGIN_TIME", beginHh[i]+beginMi[i]);
				map.put("END_TIME", endHh[i]+endMi[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				timeParamList.add(map);
			}
			params.put("timeParamList", timeParamList);

			// 상품 인원 Param
			List<Map<String, String>> nmprParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < nmprCnd.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("NMPR_CND", nmprCnd[i]);
				map.put("SETUP_AMOUNT", setupAmount[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				nmprParamList.add(map);
			}
			params.put("nmprParamList", nmprParamList);

			goodsManageService.insertGoods(params);

			result.put("message", "상품을 등록하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getLocalizedMessage());
			e.printStackTrace();
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
		param.put("UPDT_ID", ssUserId);
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> params = new HashMap<String, Object>();

		InputStream is = null;
		FileOutputStream fos = null;

		UserUtils.log("[상품등록]", param);

		try {
			// 상품 분류
			String clCode[] = request.getParameterValues("CL_CODE");

			// 상품 일정
			String beginDe[] = request.getParameterValues("BEGIN_DE");
			String endDe[] = request.getParameterValues("END_DE");
			String mon[] = UserUtils.nvl(param.get("txtMon")).split(";");
			String tue[] = UserUtils.nvl(param.get("txtTue")).split(";");
			String wed[] = UserUtils.nvl(param.get("txtWed")).split(";");
			String thu[] = UserUtils.nvl(param.get("txtThu")).split(";");
			String fri[] = UserUtils.nvl(param.get("txtFri")).split(";");
			String sat[] = UserUtils.nvl(param.get("txtSat")).split(";");
			String sun[] = UserUtils.nvl(param.get("txtSun")).split(";");

			// 상품 시간
			String beginHh[] = request.getParameterValues("BEGIN_HH");
			String beginMi[] = request.getParameterValues("BEGIN_MI");
			String endHh[] = request.getParameterValues("END_HH");
			String endMi[] = request.getParameterValues("END_MI");

			// 상품 인원
			String nmprCnd[] = request.getParameterValues("NMPR_CND");
			String setupAmount[] = request.getParameterValues("SETUP_AMOUNT");

			LOG.debug("################ Globals.fileStorePath:"+EgovProperties.getProperty("Globals.fileStorePath"));
			LOG.debug("################ File.separator:"+File.separator);

			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			LOG.debug("@@@@@@@@@@@@@@@@@@ mRequest:"+mRequest);

			List<MultipartFile> filelist = mRequest.getFiles("FILE_NM");
			//MultipartFile file = mRequest.getFile("FILE_NM");
			LOG.debug("#################### 파일수:"+filelist.size());

			// 파일 Param
			List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();
			int fileSn = 0;
			for(MultipartFile file : filelist) {
				String fileName = file.getOriginalFilename();
				LOG.debug("#################### 파일이름:"+fileName);
				if(!fileName.equals("")) {
					fileSn++;
					String saveFileNm = UserUtils.getDate("yyyyMMddHHmmss") + "_" + fileName;
					LOG.debug("$$$$$$$$$$$$$$$$$$$$ 저장파일이름:"+saveFileNm);
					LOG.debug("$$$$$$$$$$$$$$$$$$$$ getContentType:"+file.getContentType());

					String storePath = EgovProperties.getProperty("Globals.fileStorePath") + "GOODS" + File.separator;
					File f = new File(storePath);
					if (!f.exists()) {
						f.mkdirs();
					}

					fos = new FileOutputStream(storePath + saveFileNm);
					fos.write(file.getBytes());

					Map<String, String> fileParam = new HashMap<String, String>();
					fileParam.put("REGIST_PATH", "상품");
					fileParam.put("FILE_CODE", UserUtils.nvl(param.get("FILE_CODE")));
					//fileParam.put("FILE_SN", String.valueOf(fileSn)); // TODO
					fileParam.put("FILE_NM", fileName);
					fileParam.put("FILE_PATH", storePath + saveFileNm);
					fileParam.put("FILE_SIZE", String.valueOf(file.getSize()));
					fileParam.put("FILE_CL", ((file.getContentType().indexOf("image") > -1)?"I":"M")); // I:이미지, M:동영상
					fileParam.put("REPRSNT_AT", "N");
					//fileParam.put("SORT_NO", String.valueOf(fileSn)); // TODO
					fileParam.put("WRITNG_ID", param.get("WRITNG_ID"));

					LOG.debug("[fileParam]"+fileSn+")"+fileParam);

					fileParamList.add(fileParam);
				}
			}
			params.put("fileParamList", fileParamList);

			// 상품 Param
			params.put("goodsParam", param);

			// 상품 분류 Param
			List<Map<String, String>> clParamList = new ArrayList<Map<String, String>>();
			for(String str : clCode) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("CL_CODE", str);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				clParamList.add(map);
			}
			params.put("clParamList", clParamList);

			// 상품 일정 Param
			List<Map<String, String>> schdulParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < beginDe.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("BEGIN_DE", beginDe[i]);
				map.put("END_DE", endDe[i]);
				map.put("MONDAY_POSBL_AT", mon[i]);
				map.put("TUSDAY_POSBL_AT", tue[i]);
				map.put("WDNSDY_POSBL_AT", wed[i]);
				map.put("THRSDAY_POSBL_AT", thu[i]);
				map.put("FRIDAY_POSBL_AT", fri[i]);
				map.put("SATDAY_POSBL_AT", sat[i]);
				map.put("SUNDAY_POSBL_AT", sun[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				schdulParamList.add(map);
			}
			params.put("schdulParamList", schdulParamList);

			// 상품 시간 Param
			List<Map<String, String>> timeParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < beginHh.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("BEGIN_TIME", beginHh[i]+beginMi[i]);
				map.put("END_TIME", endHh[i]+endMi[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				timeParamList.add(map);
			}
			params.put("timeParamList", timeParamList);


			// 상품 인원 Param
			List<Map<String, String>> nmprParamList = new ArrayList<Map<String, String>>();
			for(int i = 0 ; i < nmprCnd.length ; i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("NMPR_CND", nmprCnd[i]);
				map.put("SETUP_AMOUNT", setupAmount[i]);
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				nmprParamList.add(map);
			}
			params.put("nmprParamList", nmprParamList);

			goodsManageService.updateGoods(params);

			result.put("message", "상품을 수정하였습니다.");
			result.put("success", true);
		} catch (Exception e) {
			LOG.error(e.getLocalizedMessage());
			e.printStackTrace();
			result.put("message", "상품 수정 중 오류가 발생했습니다.");
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

	@RequestMapping(value="/mngr/delFileDetail/")
	public void delFileDetail(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			int iCnt = fileManageService.deleteFileDetail(param);
			LOG.debug("[delFileDeatil]파일삭제 성공여부 iCnt:"+iCnt);

			if(iCnt > 0) {
				result.put("message", "파일을 삭제했습니다.");
				result.put("success", true);
			} else {
				result.put("message", "파일을 삭제하지 못했습니다.");
				result.put("success", false);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("message", "파일삭제 중 오류가 발생했습니다.");
			result.put("success", false);
		}
		jsonView.render(result, request, response);
	}
}