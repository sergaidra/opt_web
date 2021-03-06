package kr.co.siione.gnrl.goods.web;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.cs.service.QnaService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.purchs.service.WishService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.mngr.service.CtyManageService;
import kr.co.siione.mngr.service.HitManageService;
import kr.co.siione.utl.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/goods/")
public class GoodsController {

	@Resource
    private GoodsService goodsService;
	
	@Resource
	private FileService fileService;
	
	@Resource
	private CtyManageService ctyManageService;
	
	@Resource
	private ArprtManageService arprtManageService;

	@Resource
    private WishService wishService;
	
	@Resource
	private QnaService qnaService;
	
	@Resource
	private HitManageService hitManageService;

	@Resource
	private CommonService commonService;

    @RequestMapping(value="/category")
    public String category(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	String category = UserUtils.nvl(param.get("category"));
    	if("".equals(category))
    		category = "S";
    	HashMap map = new HashMap();
    	map.put("upper_cl_code", "00000");
    	List<HashMap> tourList = goodsService.getUpperTourClMain(map);
    	
        model.addAttribute("upperTourClList", tourList);
        
        model.addAttribute("bp", "01");
        if("S".equals(category))
        	model.addAttribute("btitle", commonService.getMessage("topmenu.self", request));
        else if("H".equals(category))
            model.addAttribute("btitle", commonService.getMessage("topmenu.hotdeal", request));
        else if("R".equals(category))
            model.addAttribute("btitle", commonService.getMessage("topmenu.recom", request));

        model.addAttribute("mtitle", commonService.getMessage("category.mtitle", request));
        model.addAttribute("category", category);

        return "gnrl/goods/category";
    }

    @RequestMapping(value="/list")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	try {
          	HashMap map = new HashMap();
        	UserUtils.log("[goods_list]param:", param);

        	String keyword = URLDecoder.decode(UserUtils.nvl(param.get("keyword")), "UTF-8");
        	String category = UserUtils.nvl(param.get("category"));
        	String date = UserUtils.nvl(param.get("date"));
        	String mode = UserUtils.nvl(param.get("mode"));
        	String date2 = UserUtils.nvl(param.get("date2"));
        	if("".equals(category))
        		category = "S";

        	if("".equals(keyword)) {
        		String hidUpperClCodeNavi = UserUtils.nvl(param.get("hidUpperClCodeNavi"));  // 선택한 여러개의 분류
        		String[] clArr = hidUpperClCodeNavi.split("@");
            	String goodskind = UserUtils.nvl(param.get("goodskind"));
            	
            	if(!"".equals(goodskind)) {
                	List<HashMap> upperTourClList = new ArrayList();
            		if("H".equals(goodskind)) {
            			category = "H";
            			HashMap mapGoods = new HashMap();
            			mapGoods.put("CL_NM", commonService.getMessage("topmenu.hotdeal", request));
            			mapGoods.put("CL_CODE", "H");
            			upperTourClList.add(mapGoods);
            		} else if("R".equals(goodskind)) {
            			category = "R";
            			HashMap mapGoods = new HashMap();
            			mapGoods.put("CL_NM", commonService.getMessage("topmenu.recom", request));
            			mapGoods.put("CL_CODE", "R");
            			upperTourClList.add(mapGoods);
	        		} else if("P".equals(goodskind)) {
	        			category = "P";
	        			HashMap mapGoods = new HashMap();
	        			mapGoods.put("CL_NM", commonService.getMessage("topmenu.package", request));
	        			mapGoods.put("CL_CODE", "P");

            			HashMap mapT = new HashMap();
                		mapT.put("cl_code", "00591");
                		List<HashMap> lst = goodsService.getUpperTourClMain(mapT);
            			if(lst.size() > 0)
    	        			mapGoods.put("DC", lst.get(0).get("DC"));
            				
	        			upperTourClList.add(mapGoods);
	        		} else if("C".equals(goodskind)) {
	        			category = "C";
	        			HashMap mapGoods = new HashMap();
	        			mapGoods.put("CL_NM", commonService.getMessage("topmenu.custom", request));
	        			mapGoods.put("CL_CODE", "C");
	        			
            			HashMap mapT = new HashMap();
                		mapT.put("cl_code", "00412");
                		List<HashMap> lst = goodsService.getUpperTourClMain(mapT);
            			if(lst.size() > 0)
    	        			mapGoods.put("DC", lst.get(0).get("DC"));
	        			
	        			upperTourClList.add(mapGoods);
	        		}
                	model.addAttribute("upperTourClList", upperTourClList);
            	} else {
            		// 상위 분류목록
                   	//List<String> clList = new ArrayList<String>();
                   	List<HashMap> upperTourClList = new ArrayList();
            		for(String str:clArr){
            			if(!str.isEmpty()) {
            				//clList.add(str);
                    		HashMap mapT = new HashMap();
                    		mapT.put("cl_code", str);
                        	System.out.println("[상위 분류목록]map:"+mapT);
                        	upperTourClList.addAll(goodsService.getUpperTourClMain(mapT));
            			}
            		}
                	model.addAttribute("upperTourClList", upperTourClList);
            	}
        		
            	model.addAttribute("totalsearch", "N");
            	model.addAttribute("keyword", "");
        	} else {
            	model.addAttribute("keyword", keyword);
            	model.addAttribute("totalsearch", "Y");
        	}

            model.addAttribute("bp", "01");
            if("S".equals(category))
            	model.addAttribute("btitle", commonService.getMessage("topmenu.self", request));
            else if("H".equals(category))
                model.addAttribute("btitle", commonService.getMessage("topmenu.hotdeal", request));
            else if("R".equals(category))
                model.addAttribute("btitle", commonService.getMessage("topmenu.recom", request));
            else if("P".equals(category))
                model.addAttribute("btitle", commonService.getMessage("topmenu.package", request));
            else if("C".equals(category))
                model.addAttribute("btitle", commonService.getMessage("topmenu.custom", request));
            model.addAttribute("mtitle", commonService.getMessage("goodslist.mtitle", request));
            model.addAttribute("category", category);
            model.addAttribute("date", date);
            model.addAttribute("mode", mode);
            model.addAttribute("date2", date2);
    	} catch(Exception e) {
    		e.printStackTrace();
    	}

        return "gnrl/goods/list";
    }
    
    @RequestMapping(value="/getClInfo")
    public @ResponseBody Map getClInfo(HttpServletRequest request, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	HttpSession session = request.getSession();
    	String hidUpperClCode = UserUtils.nvl(param.get("hidUpperClCode"));  // 선택한 여러개의 분류
    	String keyword = UserUtils.nvl(param.get("keyword"));  // 검색어
		String category = UserUtils.nvl(param.get("category")); // 셀프, 핫딜, 추천
		String date = UserUtils.nvl(param.get("date")); 
		String mode = UserUtils.nvl(param.get("mode")); 
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String user_id = UserUtils.nvl((String)session.getAttribute("user_id"));
		map.put("date", date);
		map.put("mode", mode);
    	if("H".equals(hidUpperClCode) || "R".equals(hidUpperClCode) || "P".equals(hidUpperClCode) || "C".equals(hidUpperClCode)) {	// 핫딜이나 추천일때
        	map.put("upper_cl_code", hidUpperClCode);  
        	map.put("category", hidUpperClCode);
    	} else {
        	// 상세 분류목록
        	map.put("upper_cl_code", hidUpperClCode);  
        	map.put("category", category);
    	}
    	if(!"".equals(keyword)) {
        	String[] arrKeyword = keyword.split(",");
        	map.put("keyword", arrKeyword);
    	}
    	map.put("esntl_id", esntl_id);    	
    	map.put("user_id", user_id);    	
    	System.out.println("[상세 분류목록]map:"+map);
    	List<HashMap> tourClList = goodsService.getUpperTourClList(map);
    	
    	// 도시 목록
    	Map<String, String> mapT2 = new HashMap<String, String>();
    	mapT2.put("NATION_CODE", "00100"); //필리핀
    	List<Map<String,String>> ctyList = ctyManageService.selectCtyList(mapT2);

    	Map resultMap = new HashMap();
    	resultMap.put("tourClList", tourClList);
    	resultMap.put("ctyList", ctyList);
    	return resultMap;
    }

    @RequestMapping(value="/getGoodsList")
    public @ResponseBody Map<String, Object> getGoodsList(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();
    	HttpSession session = request.getSession();

		String hidUpperClCode = UserUtils.nvl(param.get("hidUpperClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
		String hidClCode = UserUtils.nvl(param.get("hidClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
		String hidCtyCode = UserUtils.nvl(param.get("hidCtyCode")); // 도시
		String hidSortOrd = UserUtils.nvl(param.get("hidSortOrd")); // 정렬기준
		String hidKeyword = UserUtils.nvl(param.get("hidKeyword")); // 검색어
		String category = UserUtils.nvl(param.get("category")); // 셀프, 핫딜, 추천
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String user_id = UserUtils.nvl((String)session.getAttribute("user_id"));
		String date = UserUtils.nvl(param.get("date")); 
		String mode = UserUtils.nvl(param.get("mode")); 
		String date2 = UserUtils.nvl(param.get("date2")); 

		String hidNext = UserUtils.nvl(param.get("hidNext")); // 다음페이지 여부
		String paramPage = UserUtils.nvl(param.get("hidPage")); // 페이지번호
		if("".equals(paramPage))
			paramPage = "1";
		int hidPage = Integer.parseInt(paramPage); // 페이지번호 
		int startIdx = (hidPage - 1) * 10 + 1;
		int endIdx = hidPage * 10;

    	if(!"".equals(hidKeyword)) {
        	String[] arrKeyword = hidKeyword.split(",");
        	map.put("keyword", arrKeyword);
    	}

    	map.put("cty_code", hidCtyCode);   
    	map.put("cl_code", hidClCode);   
    	map.put("upper_cl_code", hidUpperClCode);   
    	map.put("sortOrd", hidSortOrd);   
    	map.put("category", category);       	
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	map.put("esntl_id", esntl_id);
    	map.put("user_id", user_id);
    	
		map.put("date", date);
		map.put("mode", mode);
		map.put("date2", date2);

    	System.out.println("[상품목록]map:"+map);
    	if("N".equals(hidNext)) {
    		int totalCount = goodsService.getGoodsListCount(map);
        	mapResult.put("totalCount", String.valueOf(totalCount));
    	}
    	List<HashMap> list = goodsService.getGoodsList(map);    	
    	mapResult.put("list", list);

    	return mapResult;
    }

    @RequestMapping(value="/detail")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	try {
          	HashMap map = new HashMap();
        	UserUtils.log("[goods_detail]param:", param);
    		String date = UserUtils.nvl(param.get("date")); 
    		String mode = UserUtils.nvl(param.get("mode")); 
    		String date2 = UserUtils.nvl(param.get("date2")); 

        	String category = UserUtils.nvl(param.get("category"));
        	if("".equals(category))
        		category = "S";
        	String referer = request.getHeader("referer");
        	HttpSession session = request.getSession();
    		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

            String goods_code = UserUtils.nvl(param.get("hidGoodsCode"));
        	map.put("goods_code", goods_code);
        	map.put("admin_at", UserUtils.nvl(param.get("adminAt"))); // 관리자에서 미리보기할 때
        	map.put("esntl_id", esntl_id);
        	HashMap result = goodsService.getGoodsDetail(map);
        	
        	if(result == null) response.sendRedirect("/error/");
        	else {
            	if(RequestContextUtils.getLocale(request) != null && "ja".equals(RequestContextUtils.getLocale(request).getLanguage())) {
            		HashMap mapEng = goodsService.selectGoodsEngDetail(map);        		
            		result.put("GOODS_NM", mapEng.get("GOODS_NM_ENG"));
            		result.put("GOODS_INTRCN", mapEng.get("GOODS_INTRCN_ENG"));
            		result.put("GOODS_INTRCN_SIMPL", mapEng.get("GOODS_INTRCN_SIMPL_ENG"));
            		result.put("VOCHR_NTSS_REQRE_TIME", mapEng.get("VOCHR_NTSS_REQRE_TIME_ENG"));
            		result.put("VOCHR_USE_MTH", mapEng.get("VOCHR_USE_MTH_ENG"));
            		result.put("GUIDANCE_USE_TIME", mapEng.get("GUIDANCE_USE_TIME_ENG"));
            		result.put("GUIDANCE_REQRE_TIME", mapEng.get("GUIDANCE_REQRE_TIME_ENG"));
            		result.put("GUIDANCE_AGE_DIV", mapEng.get("GUIDANCE_AGE_DIV_ENG"));
            		result.put("GUIDANCE_TOUR_SCHDUL", mapEng.get("GUIDANCE_TOUR_SCHDUL_ENG"));
            		result.put("GUIDANCE_PRFPLC_LC", mapEng.get("GUIDANCE_PRFPLC_LC_ENG"));
            		result.put("GUIDANCE_EDC_CRSE", mapEng.get("GUIDANCE_EDC_CRSE_ENG"));
            		result.put("GUIDANCE_OPTN_MATTER", mapEng.get("GUIDANCE_OPTN_MATTER_ENG"));
            		result.put("GUIDANCE_PICKUP", mapEng.get("GUIDANCE_PICKUP_ENG"));
            		result.put("GUIDANCE_PRPARETG", mapEng.get("GUIDANCE_PRPARETG_ENG"));
            		result.put("GUIDANCE_INCLS_MATTER", mapEng.get("GUIDANCE_INCLS_MATTER_ENG"));
            		result.put("GUIDANCE_NOT_INCLS_MATTER", mapEng.get("GUIDANCE_NOT_INCLS_MATTER_ENG"));
            		result.put("ADIT_GUIDANCE", mapEng.get("ADIT_GUIDANCE_ENG"));
            		result.put("ATENT_MATTER", mapEng.get("ATENT_MATTER_ENG"));
            		result.put("CHANGE_REFND_REGLTN", mapEng.get("CHANGE_REFND_REGLTN_ENG"));        		
            		result.put("INTRCN_USE_TIME", mapEng.get("INTRCN_USE_TIME_ENG"));
            		result.put("INTRCN_MEET_TIME", mapEng.get("INTRCN_MEET_TIME_ENG"));
            		result.put("INTRCN_REQRE_TIME", mapEng.get("INTRCN_REQRE_TIME_ENG"));
            		result.put("INTRCN_PROVD_LANG", mapEng.get("INTRCN_PROVD_LANG_ENG"));
            		result.put("INTRCN_POSBL_AGE", mapEng.get("INTRCN_POSBL_AGE_ENG"));
            		result.put("INTRCN_PLACE", mapEng.get("INTRCN_PLACE_ENG"));
            		result.put("GOODS_NM_SUB", mapEng.get("GOODS_NM_SUB_ENG"));
            	}
            	
            	HashMap review = goodsService.getReviewScore(map);
            	String ceil_review_score = String.valueOf(review.get("CEIL_REVIEW_SCORE"));
            	String review_count = String.valueOf(review.get("REVIEW_COUNT"));    
            	String review_score = String.valueOf(review.get("REVIEW_SCORE"));      
            	int wish_count = wishService.GoodsWishCount(map);
            	
            	//hit
            	if(!param.containsKey("adminAt")) {
            		map.put("hit_ip", UserUtils.getUserIp(request));
            		hitManageService.insertGoodsHit(map);
            	}

            	List<HashMap> lstNmpr = new ArrayList();
            	
            	if(UserUtils.nvl(result.get("CL_SE")).equals("S")) {
                	List<HashMap> lstNmpr_P = null;
                	List<HashMap> lstRoom = null;
                	List<HashMap> lstEat = null;
                	List<HashMap> lstCheckC = null;
                	List<HashMap> lstCheckB = null;
            		map.put("setup_se", "R"); // 객실(필수)
            		lstRoom = goodsService.getGoodsNmprBySetupSeList(map);
            		map.put("setup_se", "E"); // 식사
            		lstEat = goodsService.getGoodsNmprBySetupSeList(map);
            		map.put("setup_se", "C"); // 늦은 체크아웃
            		lstCheckC = goodsService.getGoodsNmprBySetupSeList(map);
            		map.put("setup_se", "B"); // 이른 체크인
            		lstCheckB = goodsService.getGoodsNmprBySetupSeList(map);
            		map.put("setup_se", "P"); // 가격/단가(필수) > 숙박 외
            		lstNmpr_P = goodsService.getGoodsNmprBySetupSeList(map);
            		lstNmpr.addAll(lstRoom);
            		lstNmpr.addAll(lstEat);
            		lstNmpr.addAll(lstCheckB);
            		lstNmpr.addAll(lstCheckC);
            		lstNmpr.addAll(lstNmpr_P);
            		model.addAttribute("E_cnt", lstEat.size());
            		model.addAttribute("C_cnt", lstCheckB.size() + lstCheckC.size());
            		model.addAttribute("P_cnt", lstNmpr_P.size());
            		//model.addAttribute("lstRoom", lstRoom);
            		//model.addAttribute("lstEat", lstEat);
            		//model.addAttribute("lstCheck", lstCheck);
            		//model.addAttribute("lstNmpr", lstNmpr);
            		
            		List<HashMap> lstRsvSchdul = goodsService.getReservationDt(map);
                    model.addAttribute("lstRsvSchdul", lstRsvSchdul);
            	} else {
            		map.put("setup_se", "P"); // 가격/단가(필수) > 숙박 외
            		List<HashMap> lstNmpr_P = goodsService.getGoodsNmprBySetupSeList(map);
            		map.put("setup_se", "V"); // 픽업/드랍(V) > 숙박 외
            		List<HashMap> lstNmpr_V = goodsService.getGoodsNmprBySetupSeList(map);
            		lstNmpr.addAll(lstNmpr_P);
            		lstNmpr.addAll(lstNmpr_V);
            		//model.addAttribute("lstNmpr_P", lstNmpr_P);
            		//model.addAttribute("lstNmpr_V", lstNmpr_V);
            		model.addAttribute("P_cnt", lstNmpr_P.size());
            		model.addAttribute("V_cnt", lstNmpr_V.size());
            	}
            	map.remove("setup_se");
            	
            	List<HashMap> lstSchdul = goodsService.getGoodsSchdulList(map);
            	List<HashMap> lstTime = goodsService.getGoodsTimeList(map);
            	
            	if(UserUtils.nvl(result.get("CL_SE")).equals("P")) {
            		HashMap map2 = new HashMap();
            		map2.put("USE_AT", "Y");
            		List<Map<String, String>> lstFlight = arprtManageService.selectArprtList(map2);
            		model.addAttribute("lstFlight", lstFlight);
            	}
            	map.put("file_code", result.get("FILE_CODE"));
            	map.put("hotdeal_at", "N");
            	map.put("recomend_at", "N");
            	map.put("liveview_at", "N");
            	List<HashMap> lstFile = fileService.getFileList(map);
            	
            	List<Map<String, String>> lstVoucher = new ArrayList();
            	List<Map<String, String>> lstOpGuide = new ArrayList();
            	List<Map<String, String>> lstEtcInfo = new ArrayList();

            	// 바우처
            	if(!isEmpty(result, "VOCHR_TICKET_TY")) {
            		Map<String, String> m = new HashMap<String, String>();
            		m.put("text", "티켓형태");
            		String ty = String.valueOf(result.get("VOCHR_TICKET_TY"));
            		if("V".equals(ty))
            			m.put("value", "E-바우처");
            		else if("T".equals(ty))
            			m.put("value", "E-티켓(캡쳐가능)");
            		else if("E".equals(ty))
            			m.put("value", "확정메일(캡쳐가능)");
            		
            		lstVoucher.add(m);
            	}
            	addList(result, "VOCHR_NTSS_REQRE_TIME", lstVoucher, "발권소요시간");
            	addList(result, "VOCHR_USE_MTH", lstVoucher, "사용 방법");
            	addList(result, "GUIDANCE_USE_TIME", lstOpGuide, "이용시간");
            	addList(result, "GUIDANCE_REQRE_TIME", lstOpGuide, "소요시간");
            	addList(result, "GUIDANCE_AGE_DIV", lstOpGuide, "연령구분");
            	addList(result, "GUIDANCE_TOUR_SCHDUL", lstOpGuide, "여행일정");
            	addList(result, "GUIDANCE_PRFPLC_LC", lstOpGuide, "가격구성"); //공연장위치
            	addList(result, "GUIDANCE_EDC_CRSE", lstOpGuide, "긴급연락처"); //교육과정
            	addList(result, "GUIDANCE_OPTN_MATTER", lstOpGuide, "옵션사항");
            	addList(result, "GUIDANCE_PICKUP", lstOpGuide, "픽업");
            	addList(result, "GUIDANCE_PRPARETG", lstOpGuide, "준비물");
            	addList(result, "GUIDANCE_INCLS_MATTER", lstOpGuide, "포함사항");
            	addList(result, "GUIDANCE_NOT_INCLS_MATTER", lstOpGuide, "불포함사항");
            	addList(result, "ADIT_GUIDANCE", lstEtcInfo, "추가안내");
            	addList(result, "ATENT_MATTER", lstEtcInfo, "유의사항");
            	addList(result, "CHANGE_REFND_REGLTN", lstEtcInfo, "변경/환불규정");
            	
                model.addAttribute("bp", "01");
                if("S".equals(category))
                	model.addAttribute("btitle", "선택투어");
                else if("H".equals(category))
                    model.addAttribute("btitle", "원패스핫딜");
                else if("R".equals(category))
                    model.addAttribute("btitle", "원패스추천");
                else if("C".equals(category))
                    model.addAttribute("btitle", "맞춤투어");
                model.addAttribute("mtitle", "여행상품상세보기");
                model.addAttribute("category", category);
                
                model.addAttribute("goods_code", goods_code);
                model.addAttribute("review_score", review_score);
                model.addAttribute("review_count", review_count); 
                model.addAttribute("ceil_review_score", ceil_review_score);
                model.addAttribute("wish_count", wish_count);
                model.addAttribute("result", result);
                model.addAttribute("lstSchdul", lstSchdul);
                model.addAttribute("lstTime", lstTime);
                model.addAttribute("lstFile", lstFile);
                model.addAttribute("lstVoucher", lstVoucher);
                model.addAttribute("lstOpGuide", lstOpGuide);
                model.addAttribute("lstEtcInfo", lstEtcInfo);
                model.addAttribute("today", UserUtils.getDate("yyyy-MM-dd"));
                model.addAttribute("lstNmpr", lstNmpr);

                if(referer != null && referer.indexOf("goods/list") > -1)
                	model.addAttribute("back_goodslist", "Y");
                else
                	model.addAttribute("back_goodslist", "N");
                
        		model.addAttribute("date", date);
        		model.addAttribute("mode", mode);
        		model.addAttribute("date2", date2);
        	}
    	} catch(Exception e) {
    		e.printStackTrace();
    	}

        return "gnrl/goods/detail";
    }
    
    @RequestMapping(value="/getReview")
    public @ResponseBody Map getReview(@RequestBody HashMap param) throws Exception {
      	HashMap map = new HashMap();
    	Map<String, Object> mapResult = new HashMap<String, Object>();

    	String goods_code = UserUtils.nvl(param.get("goods_code"));
		int hidPage = Integer.parseInt(UserUtils.nvl(param.get("hidPage"))); // 페이지번호
		int startIdx = (hidPage - 1) * 5 + 1;
		int endIdx = hidPage * 5;

    	map.put("goods_code", goods_code); 
    	map.put("hidPage", hidPage);
    	map.put("startIdx", startIdx);
    	map.put("endIdx", endIdx);
    	
    	int totalCount = goodsService.getReviewCount(map);
    	List<HashMap> list = goodsService.getReview(map);
    	
    	mapResult.put("totalCount", String.valueOf(totalCount));
    	mapResult.put("startIdx", String.valueOf(startIdx));
    	mapResult.put("list", list);

    	return mapResult;    
    }    


    


    private boolean isEmpty(Map map, String key) {
    	if(!map.containsKey(key) || map.get(key) == null || "".equals(String.valueOf(map.get(key)).trim()))
    		return true;
    	else
    		return false;
    }

    private void addList(Map map, String key, List<Map<String, String>> lst, String text) {
    	if(!isEmpty(map, key)) {
    		Map<String, String> m = new HashMap<String, String>();
    		m.put("text", text);
    		m.put("value", String.valueOf(map.get(key)));
    		lst.add(m);
    	}
    }

    @RequestMapping(value="/list2")
    public String list2(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	
    	try {
          	HashMap map = new HashMap();
        	UserUtils.log("[goods_list]param:", param);
        	
    		String hidUpperClCodeNavi = UserUtils.nvl(param.get("hidUpperClCodeNavi"));  // 선택한 여러개의 분류
    		String hidUpperClCode = UserUtils.nvl(param.get("hidUpperClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
    		String hidClCode = UserUtils.nvl(param.get("hidClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
    		String hidCtyCode = UserUtils.nvl(param.get("hidCtyCode")); // 도시

    		String[] clArr = hidUpperClCodeNavi.split("@");
           	if(clArr != null && hidUpperClCode.equals("")) hidUpperClCode = clArr[0];

    		// 상위 분류목록
           	List<String> clList = new ArrayList<String>();
    		for(String str:clArr){
    			if(!str.isEmpty()) clList.add(str);
    		}
    		HashMap mapT = new HashMap();
    		mapT.put("cl_code_arr", clList);
        	System.out.println("[상위 분류목록]map:"+mapT);
        	List<HashMap> upperTourClList = goodsService.getUpperTourClMain(mapT);
        	
        	// 상세 분류목록
        	map.put("upper_cl_code", hidUpperClCode);  
        	System.out.println("[상세 분류목록]map:"+map);
        	List<HashMap> tourClList = goodsService.getUpperTourClMain(map);
        	
        	// 도시 목록
        	Map<String, String> mapT2 = new HashMap<String, String>();
        	mapT2.put("NATION_CODE", "00001");
        	List<Map<String,String>> ctyList = ctyManageService.selectCtyList(mapT2);

        	/********************* 페이징 start ****************************************/ 
            //현재 페이지 파라메타
            String hidPage = UserUtils.nvl(request.getParameter("hidPage"));
            int intPage = 1;
    		if(!hidPage.equals(""))		
    			intPage = Integer.parseInt((String)hidPage);
    		
    		//페이지 기본설정
    		int pageBlock = 6;
    		int pageArea = 10;
        	
        	PaginationInfo paginationInfo = new PaginationInfo();
    		paginationInfo.setCurrentPageNo(intPage);
    		paginationInfo.setRecordCountPerPage(pageBlock);
    		paginationInfo.setPageSize(pageArea);

        	map.put("startRow", paginationInfo.getFirstRecordIndex());
        	map.put("endRow", paginationInfo.getLastRecordIndex());
        	/********************* 페이징 end ******************************************/

    		// 상품목록
        	map.put("cty_code", hidCtyCode);   
        	map.put("cl_code", hidClCode);   
        	System.out.println("[상품목록]map:"+map);
        	List<HashMap> list = goodsService.getGoodsList(map);

        	/********************* 페이징(2) start ****************************************/ 
    		if(list.size() > 0){
    			int list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
    			paginationInfo.setTotalRecordCount(list_cnt);
    		}
            model.addAttribute("paginationInfo", paginationInfo);    		
        	/********************* 페이징(2) end ******************************************/    		

            model.addAttribute("goods_list_yn", "Y");
            
            model.addAttribute("hidPage", hidPage);
            model.addAttribute("hidCtyCode", hidCtyCode);
            model.addAttribute("hidClCode", hidClCode);
            model.addAttribute("hidUpperClCode", hidUpperClCode);
            model.addAttribute("hidUpperClCodeNavi", hidUpperClCodeNavi);

            model.addAttribute("upperTourClList", upperTourClList);
            model.addAttribute("tourClList", tourClList);
            model.addAttribute("ctyList", ctyList);
            model.addAttribute("goodsList", list);    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}

        return "gnrl/goods/list";
    }


    @RequestMapping(value="/detail2")
    public String detail2(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	try{
    	
        String goods_code = UserUtils.nvl(request.getParameter("hidGoodsCode"));
        String hidUpperClCodeNavi = UserUtils.nvl(request.getParameter("hidUpperClCodeNavi"));
        String hidUpperClCode = UserUtils.nvl(request.getParameter("hidUpperClCode"));
        String hidClCode = UserUtils.nvl(request.getParameter("hidClCode"));
        String hidPage = UserUtils.nvl(request.getParameter("hidPage"));

    	HashMap map = new HashMap();
    	map.put("goods_code", goods_code);
    	HashMap result = goodsService.getGoodsDetail(map);
    	
    	HashMap mapT = new HashMap();
    	mapT.put("goods_code", goods_code);
    	List<HashMap> nmprList = null;
    	List<HashMap> roomList = null;
    	List<HashMap> eatList = null;
    	List<HashMap> checkList = null;
    	
    	if(UserUtils.nvl(result.get("CL_SE")).equals("S")) { // > 숙박
    		mapT.put("setup_se", "R"); // 객실(필수)
    		roomList = goodsService.getGoodsNmprBySetupSeList(mapT);
    		mapT.put("setup_se", "E"); // 식사
    		eatList = goodsService.getGoodsNmprBySetupSeList(mapT);
    		mapT.put("setup_se", "C"); // 체크인/아웃
    		checkList = goodsService.getGoodsNmprBySetupSeList(mapT);
    	} else {
    		mapT.put("setup_se", "P"); // 가격/단가(필수) > 숙박 외
    		nmprList = goodsService.getGoodsNmprBySetupSeList(mapT);
    	}
    	
   	
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> timeList = goodsService.getGoodsTimeList(map);
    	
    	map.put("file_code", result.get("FILE_CODE"));
    	List<HashMap> fileList = fileService.getFileList(map);
    	
    	model.addAttribute("goods_detail_yn", "Y");

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("hidUpperClCodeNavi", hidUpperClCodeNavi);
        model.addAttribute("hidUpperClCode", hidUpperClCode);
        model.addAttribute("hidClCode", hidClCode);
        model.addAttribute("hidGoodsCode", goods_code);
        model.addAttribute("goods_code", goods_code);

        model.addAttribute("result", result);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("timeList", timeList);
        model.addAttribute("fileList", fileList);
        
        if(UserUtils.nvl(result.get("CL_SE")).equals("S")) {
        	model.addAttribute("roomList", roomList);
        	model.addAttribute("eatList", eatList);
        	model.addAttribute("checkList", checkList);
        } else {
        	model.addAttribute("nmprList", nmprList);
        }
        
        model.addAttribute("today", UserUtils.getDate("yyyy-MM-dd"));

    	} catch (Exception e) {e.printStackTrace();}
        
        return "gnrl/goods/detail";
    }
 
}
