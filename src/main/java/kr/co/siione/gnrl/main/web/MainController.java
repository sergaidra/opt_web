package kr.co.siione.gnrl.main.web;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.gnrl.goods.service.GoodsService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/main/")
public class MainController {
    
	@Resource
    private GoodsService goodsService;
	
    @RequestMapping(value="/intro/")
    public String intro(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	List<HashMap> expsrList1 = goodsService.getGoodsExpsrList1();
    	List<HashMap> expsrList2 = goodsService.getGoodsExpsrList2();
    	
        model.addAttribute("expsrList1", expsrList1);
        model.addAttribute("expsrList2", expsrList2);
        model.addAttribute("main_yn", "Y");
    	
        return "gnrl/main/intro";
    }
 
    @RequestMapping(value="/indexAction/")
    public String frameReset(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/main/index";
    }
}
