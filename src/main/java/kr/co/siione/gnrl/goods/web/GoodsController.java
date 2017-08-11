package kr.co.siione.gnrl.goods.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.UserUtils;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/goods/")
public class GoodsController {

	@Resource
    private GoodsService goodsService;
    
    @RequestMapping(value="/category/")
    public String category(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	HashMap map = new HashMap();
    	List<HashMap> tourList = goodsService.getTourClMain(map);
    	
    	String clCodeStayng = goodsService.getTourClStayng(map);
    	
        model.addAttribute("tourList", tourList);
        model.addAttribute("clCodeStayng", clCodeStayng);

        return "gnrl/goods/category";
    }

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	
    	UserUtils.log("[goods_list]param:", param);
    	
		String hidCategoryNavi = UserUtils.nvl(request.getParameter("hidCategoryNavi"));  // 선택한 여러개의 분류
		String hidCategory = UserUtils.nvl(request.getParameter("hidCategory")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
		String hidStayngFcltyAt = UserUtils.nvl(request.getParameter("hidStayngFcltyAt"));

		String[] clArr = hidCategoryNavi.split("@");
       	if(clArr != null && hidCategory.equals("")) hidCategory = clArr[0];
       	
        //현재 페이지 파라메타
        String hidPage = UserUtils.nvl(request.getParameter("hidPage"));
        int intPage = 1;
		if(!hidPage.equals(""))		
			intPage = Integer.parseInt((String)hidPage);
		
		//페이지 기본설정
		int pageBlock = 6;
		int pageArea = 10;
        
		// 검색할 분류 목록 조회
       	List<String> clList = new ArrayList<String>();
		for(String str:clArr){
			if(!str.isEmpty()) clList.add(str);
		}
		
    	HashMap map = new HashMap();
    	map.put("cl_code_arr", clList);
    	map.put("stayng_fclty_at", hidStayngFcltyAt);
    	List<HashMap> tourList = goodsService.getTourClList(map);
    	
    	// 숙박 시설
    	if(hidStayngFcltyAt.equals("Y") && hidCategoryNavi.equals("")) {
			for(HashMap clmap : tourList) {
				hidCategoryNavi += clmap.get("CL_CODE").toString() + "@";
			}
			if(hidCategory.equals("")) hidCategory = tourList.get(0).get("CL_CODE").toString();
    	}
    	map.put("cl_code", hidCategory);
    	
    	UserUtils.log("[good_list]map:", map);

    	//page 
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

    	map.put("startRow", paginationInfo.getFirstRecordIndex());
    	map.put("endRow", paginationInfo.getLastRecordIndex());

		int list_cnt = 0;
    	List<HashMap> list = goodsService.getGoodsList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			paginationInfo.setTotalRecordCount(list_cnt);
		}

        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("hidCategory", hidCategory);
        model.addAttribute("hidCategoryNavi", hidCategoryNavi);

        model.addAttribute("tourList", tourList);
        model.addAttribute("goodsList", list);

        return "gnrl/goods/list";
    }


    @RequestMapping(value="/detail/")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	try{
    	
        String goods_code = UserUtils.nvl(request.getParameter("hidGoodsCode"));
        String hidCategoryNavi = UserUtils.nvl(request.getParameter("hidCategoryNavi"));
        String hidCategory = UserUtils.nvl(request.getParameter("hidCategory"));
        String hidPage = UserUtils.nvl(request.getParameter("hidPage"));

    	HashMap map = new HashMap();
    	map.put("goods_code", goods_code);
    	HashMap result = goodsService.getGoodsDetail(map);
    	List<HashMap> clList = goodsService.getGoodsClList(map);
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> nmprList = goodsService.getGoodsNmprList(map);
    	List<HashMap> timeList = goodsService.getGoodsTimeList(map);
    	
    	String stayngFcltyAt = "N";
    	for(HashMap clMap : clList) {
    		if(UserUtils.nvl(clMap.get("STAYNG_FCLTY_AT")).equals("Y")) {
    			stayngFcltyAt = "Y";
    			break;
    		}
    	}
    	
    	model.addAttribute("stayngFcltyAt", stayngFcltyAt);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("hidCategoryNavi", hidCategoryNavi);
        model.addAttribute("hidCategory", hidCategory);
        model.addAttribute("goods_code", goods_code);

        model.addAttribute("result", result);
        model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);
        model.addAttribute("timeList", timeList);
        
        model.addAttribute("today", UserUtils.getDate("yyyy-MM-dd"));

    	} catch (Exception e) {e.printStackTrace();}
        
        return "gnrl/goods/detail";
    }
 
}
