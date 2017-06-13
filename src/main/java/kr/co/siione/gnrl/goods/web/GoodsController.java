package kr.co.siione.gnrl.goods.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.utl.LoginManager;
import kr.co.siione.utl.Utility;

import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import twitter4j.internal.org.json.JSONObject;

@Controller
@RequestMapping(value = "/goods/")
public class GoodsController {

	@Resource
    private GoodsService goodsService;
    
    @RequestMapping(value="/category/")
    public String login(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	HashMap map = new HashMap();
    	List<HashMap> tourList = goodsService.getTourClList(map);
        model.addAttribute("tourList", tourList);

        return "gnrl/goods/category";
    }

    @RequestMapping(value="/list/")
    public String loginAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        LoginManager loginManager = LoginManager.getInstance();
        HttpSession session = request.getSession();
        String[] category = request.getParameterValues("chkCategory");

    	HashMap map = new HashMap();
    	map.put("cl_code_arr", category);
    	List<HashMap> tourList = goodsService.getTourClList(map);    	
    	List<HashMap> goodsList = goodsService.getGoodsList(map);

        model.addAttribute("tourList", tourList);
        model.addAttribute("goodsList", goodsList);

        return "gnrl/goods/list";

    }


    
}
