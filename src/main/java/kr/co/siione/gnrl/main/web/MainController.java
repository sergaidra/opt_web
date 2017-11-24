package kr.co.siione.gnrl.main.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.main.service.MainService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/main/")
public class MainController {
    
	@Resource
    private GoodsService goodsService;

	@Resource
    private MainService mainService;

    @RequestMapping(value="/intro/")
    public String intro(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	List<HashMap> lstMainImage = mainService.getMainImageList();
    	List<HashMap> expsrList1 = goodsService.getGoodsExpsrList1();
    	List<HashMap> expsrList2 = goodsService.getGoodsExpsrList2();
    	List<HashMap> expsrList3 = goodsService.getGoodsExpsrList3();
    	List<HashMap> expsrList4 = goodsService.getGoodsExpsrList4();
    	
        //model.addAttribute("expsrList1", expsrList1);
        //model.addAttribute("expsrList2", expsrList2);
    	
        model.addAttribute("main_yn", "Y");
    	
        model.addAttribute("lstMainImage", lstMainImage);        
        model.addAttribute("hotdeal", expsrList1);
        model.addAttribute("reco", expsrList2);
        model.addAttribute("self", expsrList3);
        model.addAttribute("video", expsrList4);
        
        model.addAttribute("bp", "07");
        model.addAttribute("btitle", "고객지원");
        model.addAttribute("mtitle", "여행후기");
        
        return "gnrl/main/intro";
    }
 
    @RequestMapping(value="/indexAction/")
    public String frameReset(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/main/index";
    }
}
