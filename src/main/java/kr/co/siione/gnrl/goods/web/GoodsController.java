package kr.co.siione.gnrl.goods.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.goods.service.GoodsService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/goods/")
public class GoodsController {

	@Resource
    private GoodsService goodsService;
    
    @RequestMapping(value="/category/")
    public String category(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	HashMap map = new HashMap();
    	List<HashMap> tourList = goodsService.getTourClList(map);
        model.addAttribute("tourList", tourList);

        return "gnrl/goods/category";
    }

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String[] category = request.getParameterValues("chkCategory");
        
        //현재 페이지 파라메타
        String strPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!strPage.equals(""))		
			intPage = Integer.parseInt((String)strPage);
		
		//페이지 기본설정
		int pageBlock = 4;
		int pageArea = 10;
        
    	HashMap map = new HashMap();
    	map.put("cl_code_arr", category);
    	List<HashMap> tourList = goodsService.getTourClList(map);

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
	
        model.addAttribute("tourList", tourList);
        model.addAttribute("goodsList", list);

        return "gnrl/goods/list";
    }


    @RequestMapping(value="/detail/")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	
        String goods_code = SimpleUtils.default_set(request.getParameter("hidGoodsCode"));

    	HashMap map = new HashMap();
    	map.put("goods_code", goods_code);
    	HashMap result = goodsService.getGoodsDetail(map);
    	List<HashMap> clList = goodsService.getGoodsClList(map);
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> nmprList = goodsService.getGoodsNmprList(map);

        model.addAttribute("result", result);
        model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);

        return "gnrl/goods/detail";
    }

    
}
