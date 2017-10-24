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
import javax.servlet.http.HttpSession;

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

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);
		
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
		Map<String, Object> result = new HashMap<String, Object>();

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("WRITNG_ID", esntl_id);
		
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
		Map<String, Object> result = new HashMap<String, Object>();
		int iRe = 0;
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("WRITNG_ID", esntl_id);
		param.put("UPDT_ID", esntl_id);

		try {
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
		Map<String, Object> result = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("UPDT_ID", esntl_id);

		try {
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
		Map<String, Object> result = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("UPDT_ID", esntl_id);
		
		try {
			String[] str = UserUtils.nvl(param.get("GOODS_CODE_LIST")).split(",");
			
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
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

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

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

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
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

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

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("USER_ID", esntl_id);

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
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("WRITNG_ID", esntl_id);		

		//InputStream is = null;
		FileOutputStream fos = null;
		HashMap<String, String> fileParam = new HashMap<String, String>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			
			fileParam = UserUtils.getFileInfo(file, "GOODS", true);
			fileParam.put("REPRSNT_AT", "N");
			fileParam.putAll(param);

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

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("WRITNG_ID", esntl_id);

		//InputStream is = null;
		FileOutputStream fos = null;
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("param", param);
		
		// 파일 Param
		List<Map<String, String>> fileParamList = new ArrayList<Map<String, String>>();

		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			//MultipartFile file = mRequest.getFile("ATTACH_FLIE");
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE");
			
			for(MultipartFile file : filelist) {
				Map<String, String> fileParam = new HashMap<String, String>();
				fileParam = UserUtils.getFileInfo(file, "GOODS", true);
				fileParam.put("REPRSNT_AT", "N");
				fileParam.put("WRITNG_ID", esntl_id);

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