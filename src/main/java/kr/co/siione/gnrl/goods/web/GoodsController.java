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

    	HashMap map = new HashMap();
    	map.put("cl_code_arr", category);
    	List<HashMap> tourList = goodsService.getTourClList(map);    	
    	List<HashMap> goodsList = goodsService.getGoodsList(map);

        model.addAttribute("tourList", tourList);
        model.addAttribute("goodsList", goodsList);

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
