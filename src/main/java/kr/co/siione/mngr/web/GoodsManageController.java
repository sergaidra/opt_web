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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class GoodsManageController {

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
        return "/mngr/goodsManage";
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
        return "/mngr/goodsRegist";	
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
		
        return "/mngr/goodsModify";	
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

			/*for(String str : clCode) System.out.println("[clCode] "+str);
			for(String str : beginHh) System.out.println("[beginHh] "+str);
			for(String str : beginMi) System.out.println("[beginMi] "+str);
			for(String str : endHh) System.out.println("[endHh] "+str);
			for(String str : endMi) System.out.println("[endMi] "+str);
			for(String str : beginDe) System.out.println("[beginDe] "+str);
			for(String str : endDe) System.out.println("[endDe] "+str);
			for(String str : mon) System.out.println("[mon] "+str);
			for(String str : tue) System.out.println("[tue] "+str);
			for(String str : wed) System.out.println("[wed] "+str);
			for(String str : thu) System.out.println("[thu] "+str);
			for(String str : fri) System.out.println("[fri] "+str);
			for(String str : sat) System.out.println("[sat] "+str);
			for(String str : sun) System.out.println("[sun] "+str);*/
			
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

			/*for(String str : clCode) System.out.println("[clCode] "+str);
			for(String str : beginHh) System.out.println("[beginHh] "+str);
			for(String str : beginMi) System.out.println("[beginMi] "+str);
			for(String str : endHh) System.out.println("[endHh] "+str);
			for(String str : endMi) System.out.println("[endMi] "+str);
			for(String str : beginDe) System.out.println("[beginDe] "+str);
			for(String str : endDe) System.out.println("[endDe] "+str);
			for(String str : mon) System.out.println("[mon] "+str);
			for(String str : tue) System.out.println("[tue] "+str);
			for(String str : wed) System.out.println("[wed] "+str);
			for(String str : thu) System.out.println("[thu] "+str);
			for(String str : fri) System.out.println("[fri] "+str);
			for(String str : sat) System.out.println("[sat] "+str);
			for(String str : sun) System.out.println("[sun] "+str);*/
			
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
			System.out.println("[delFileDeatil]파일삭제 성공여부 iCnt:"+iCnt);
			
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