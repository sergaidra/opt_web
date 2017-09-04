package kr.co.siione.gnrl.goods.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.gnrl.cmmn.service.FileService;
import kr.co.siione.gnrl.goods.service.GoodsService;
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
	
	@Resource
	private FileService fileService;
    
    @RequestMapping(value="/category/")
    public String category(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	HashMap map = new HashMap();
    	map.put("upper_cl_code", "00000");
    	List<HashMap> tourList = goodsService.getUpperTourClMain(map);
    	
        model.addAttribute("upperTourClList", tourList);

        return "gnrl/goods/category";
    }

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam HashMap param) throws Exception {
    	
    	try {
          	HashMap map = new HashMap();
          	HashMap map2 = new HashMap();
        	UserUtils.log("[goods_list]param:", param);
        	
    		String hidUpperClCodeNavi = UserUtils.nvl(param.get("hidUpperClCodeNavi"));  // 선택한 여러개의 분류
    		String hidUpperClCode = UserUtils.nvl(param.get("hidUpperClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류
    		String hidClCode = UserUtils.nvl(param.get("hidClCode")); // 첫번째 선택한 한개의 분류 OR 선택한 한개의 분류

    		String[] clArr = hidUpperClCodeNavi.split("@");
           	if(clArr != null && hidUpperClCode.equals("")) hidUpperClCode = clArr[0];

    		// 상위 분류목록
           	List<String> clList = new ArrayList<String>();
    		for(String str:clArr){
    			if(!str.isEmpty()) clList.add(str);
    		}
        	map2.put("cl_code_arr", clList);
        	System.out.println("[상위 분류목록]map:"+map2);
        	List<HashMap> upperTourClList = goodsService.getUpperTourClMain(map2);
        	
        	// 상세 분류목록
        	map.put("upper_cl_code", hidUpperClCode);  
        	System.out.println("[상세 분류목록]map:"+map);
        	List<HashMap> tourClList = goodsService.getUpperTourClMain(map);

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
            model.addAttribute("hidClCode", hidClCode);
            model.addAttribute("hidUpperClCode", hidUpperClCode);
            model.addAttribute("hidUpperClCodeNavi", hidUpperClCodeNavi);

            model.addAttribute("upperTourClList", upperTourClList);
            model.addAttribute("tourClList", tourClList);
            model.addAttribute("goodsList", list);    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}

        return "gnrl/goods/list";
    }


    @RequestMapping(value="/detail/")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	try{
    	
        String goods_code = UserUtils.nvl(request.getParameter("hidGoodsCode"));
        String hidUpperClCodeNavi = UserUtils.nvl(request.getParameter("hidUpperClCodeNavi"));
        String hidUpperClCode = UserUtils.nvl(request.getParameter("hidUpperClCode"));
        String hidClCode = UserUtils.nvl(request.getParameter("hidClCode"));
        String hidPage = UserUtils.nvl(request.getParameter("hidPage"));

    	HashMap map = new HashMap();
    	map.put("goods_code", goods_code);
    	HashMap result = goodsService.getGoodsDetail(map);
    	//List<HashMap> clList = goodsService.getGoodsClList(map);
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> nmprList = goodsService.getGoodsNmprList(map);
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
        //model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);
        model.addAttribute("timeList", timeList);
        model.addAttribute("fileList", fileList);
        
        model.addAttribute("today", UserUtils.getDate("yyyy-MM-dd"));

    	} catch (Exception e) {e.printStackTrace();}
        
        return "gnrl/goods/detail";
    }
 
}
