package kr.co.siione.gnrl.bbs.web;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cart.service.FlightService2;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.utl.UserUtils;
import kr.co.siione.utl.egov.EgovProperties;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/bbs/")
@PropertySource("classpath:property/globals.properties")
public class BbsController {

	@Resource
	private BbsService bbsService;

	@Value("#{globals['Globals.fileStorePath']}")
	private String fileStorePath;

	private static final Logger LOG = LoggerFactory.getLogger(BbsController.class);

	@RequestMapping(value="/list")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {

		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("category", "R");

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행상담");
        model.addAttribute("mtitle", "");
		
		return "gnrl/bbs/bbslist";
	}

    @RequestMapping(value="/getBbsList")
    public @ResponseBody Map<String, Object> getBbsList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		String category = UserUtils.nvl(param.get("category"));
		String keyword = UserUtils.nvl(param.get("keyword"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 10 + 1;
		int endIdx = hidPage * 10;

    	map.put("esntl_id", esntl_id);   
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	map.put("category", category);
    	map.put("keyword", keyword);
    	System.out.println("[getBbsList]map:"+map);
		int totalCount = bbsService.selectBbsListCount(map);
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("startIdx", String.valueOf(startIdx));
    	List<HashMap> bbsList = new ArrayList();
    	List<HashMap> list = bbsService.selectBbsList(map);    	
    	for(int i = 0; i < list.size(); i++) {
    		bbsList.add(list.get(i));
    		
    		HashMap mapChild = new HashMap();
    		mapChild.put("bbs_sn", list.get(i).get("BBS_SN"));
    		List<HashMap> lstChild = bbsService.selectChildBbsList(mapChild);
    		if(lstChild.size() > 0) {
    			for(int j = 0; j < lstChild.size(); j++)
    				bbsList.add(lstChild.get(j));
    		}
    	}
    	mapResult.put("list", bbsList);

    	return mapResult;
    }
	@RequestMapping(value="/write")
	public String write(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
			String user_nm = UserUtils.nvl((String)session.getAttribute("user_nm"));
			String email = UserUtils.nvl((String)session.getAttribute("email"));
			
			SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd" );
			Date currentTime = new Date ();

			HashMap view = new HashMap();
			view.put("USER_NM", user_nm);
			view.put("EMAIL", email);
			view.put("WRITNG_DT", mSimpleDateFormat.format ( currentTime ));
			model.addAttribute("view", view);
		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행상담");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "write");

		return "gnrl/bbs/bbsview";
	}

	@RequestMapping(value="/writeaction")
	public @ResponseBody ResponseVo writeaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String category = UserUtils.nvl(param.get("category"));
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));
			String secret_at = UserUtils.nvl(param.get("secret_at"));
			String subcategory = UserUtils.nvl(param.get("subcategory"));
			String parent_bbs_sn = UserUtils.nvl(param.get("parent_bbs_sn"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	
			map.put("secret_at", secret_at);	
			map.put("subcategory", subcategory);	
			map.put("parent_bbs_sn", parent_bbs_sn);	

			UserUtils.log("[writeaction-map]", map);
			
			bbsService.insertBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/view")
	public String view(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = bbsService.viewBbs(map);
			bbsService.updateBbsViewCnt(map);
			
			String contents = String.valueOf(view.get("CONTENTS")).replaceAll("\\n", "<br>");
			view.put("CONTENTS", contents);
			model.addAttribute("view", view);
			
			List<HashMap> lstComment = bbsService.selectCommentList(map);
			model.addAttribute("lstComment", lstComment);
		
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행상담");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "view");

		return "gnrl/bbs/bbsview";
	}
	
	@RequestMapping(value="/deleteaction")
	public @ResponseBody ResponseVo deleteaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("bbs_sn", bbs_sn);			

			UserUtils.log("[deleteaction-map]", map);
			
			bbsService.deleteBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/modify")
	public String modify(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		if("".equals(esntl_id))
			response.sendRedirect("/member/login/");

		String bbs_sn = UserUtils.nvl(request.getParameter("bbs_sn"));

		HashMap map = new HashMap();
		map.put("bbs_sn", bbs_sn);

		try {
			HashMap view = bbsService.viewBbs(map);
			model.addAttribute("view", view);
		} catch(Exception e) {e.printStackTrace();}

        model.addAttribute("bp", "07");
       	model.addAttribute("btitle", "여행상담");
        model.addAttribute("mtitle", "");

        model.addAttribute("mode", "modify");

		return "gnrl/bbs/bbsview";
	}

	@RequestMapping(value="/modifyaction")
	public @ResponseBody ResponseVo modifyaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String category = UserUtils.nvl(param.get("category"));
			String subject = UserUtils.nvl(param.get("subject"));
			String contents = UserUtils.nvl(param.get("contents"));
			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));
			String secret_at = UserUtils.nvl(param.get("secret_at"));
			String subcategory = UserUtils.nvl(param.get("subcategory"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("category", category);			
			map.put("subject", subject);			
			map.put("contents", contents);	
			map.put("bbs_sn", bbs_sn);	
			map.put("secret_at", secret_at);	
			map.put("subcategory", subcategory);	

			UserUtils.log("[writeaction-map]", map);
			
			bbsService.updateBbs(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}

	@RequestMapping(value="/writecommentaction")
	public @ResponseBody ResponseVo writecommentaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String cmt = UserUtils.nvl(param.get("cmt"));
			String bbs_sn = UserUtils.nvl(param.get("bbs_sn"));

			HashMap map = new HashMap();	
			map.put("esntl_id", esntl_id);			
			map.put("cmt", cmt);			
			map.put("bbs_sn", bbs_sn);			

			UserUtils.log("[writecommentaction-map]", map);
			
			bbsService.insertComment(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}
	
	@RequestMapping(value="/deletecommentaction")
	public @ResponseBody ResponseVo deletecommentaction(HttpServletRequest request, HttpServletResponse response, @RequestBody Map param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
			HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			String comment_sn = UserUtils.nvl(param.get("comment_sn"));

			HashMap map = new HashMap();	
			map.put("comment_sn", comment_sn);			

			UserUtils.log("[deletecommentaction-map]", map);
			
			bbsService.deleteComment(map);
				
			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;
	}	
	
	@RequestMapping(value="/popupAttachImage")
	public String popupAttachImage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		FileOutputStream fos = null;
		
		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE"); // 파일 1개 이상
			
			for(MultipartFile file : filelist) {
				String sFileStorePath = fileStorePath + "bbs" + File.separator + "img" + File.separator;
				String sPreFix = UserUtils.getDate("yyyyMMddHHmmss");
				
				String fileName = file.getOriginalFilename();
				String saveFileNm = sPreFix + "_" + fileName;

				String storePath  = sFileStorePath;
				File f = new File(storePath);
				if (!f.exists()) f.mkdirs();
							
				fos = new FileOutputStream(storePath + saveFileNm);
				fos.write(file.getBytes());
				
				String imageUrl = "/files/bbs/img/" + saveFileNm;
				model.addAttribute("imageurl", imageUrl);
				model.addAttribute("filename", fileName);
				model.addAttribute("filesize", file.getSize());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null) fos.close();
		}

		return "gnrl/bbs/attachImage";
	}		
	
	@RequestMapping(value="/popupAttachFile")
	public String popupAttachFile(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		FileOutputStream fos = null;
		
		try {
			MultipartHttpServletRequest mRequest = (MultipartHttpServletRequest) request;
			List<MultipartFile> filelist = mRequest.getFiles("ATTACH_FLIE"); // 파일 1개 이상
			
			for(MultipartFile file : filelist) {
				String sFileStorePath = fileStorePath + "bbs" + File.separator + "file" + File.separator;
				String sPreFix = UserUtils.getDate("yyyyMMddHHmmss");
				
				String fileName = file.getOriginalFilename();
				String saveFileNm = sPreFix + "_" + fileName;

				String storePath  = sFileStorePath;
				File f = new File(storePath);
				if (!f.exists()) f.mkdirs();
							
				fos = new FileOutputStream(storePath + saveFileNm);
				fos.write(file.getBytes());
				
				String attachurl = "/files/bbs/file/" + saveFileNm;
				model.addAttribute("attachurl", attachurl);
				model.addAttribute("filename", fileName);
				model.addAttribute("filemime", "application/unknown");				
				model.addAttribute("filesize", file.getSize());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fos != null) fos.close();
		}

		return "gnrl/bbs/attachFile";
	}			
}