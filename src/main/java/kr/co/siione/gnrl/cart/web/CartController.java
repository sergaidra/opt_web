package kr.co.siione.gnrl.cart.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.utl.LoginManager;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/cart/")
public class CartController {

	@Resource
    private GoodsService goodsService;

	@Resource
    private CartService cartService;

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!hidPage.equals(""))		
			intPage = Integer.parseInt((String)hidPage);
		
		//페이지 기본설정
		int pageBlock = 4;
		int pageArea = 10;
        
    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);

    	//page 
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

    	map.put("startRow", paginationInfo.getFirstRecordIndex());
    	map.put("endRow", paginationInfo.getLastRecordIndex());

		int list_cnt = 0;
    	List<HashMap> list = cartService.getCartList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			paginationInfo.setTotalRecordCount(list_cnt);
		}

        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("hidPage", hidPage);
        
        model.addAttribute("list", list);

        return "gnrl/cart/list";
    }


    @RequestMapping(value="/detail/")
    public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        String cart_sn = SimpleUtils.default_set(request.getParameter("hidCartSn"));
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));

    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
    	map.put("cart_sn", cart_sn);
    	HashMap result = cartService.getCartDetail(map);
    	
    	String goods_code = (String) result.get("GOODS_CODE");
    	
    	map.put("goods_code", goods_code);
    	List<HashMap> clList = goodsService.getGoodsClList(map);
    	List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
    	List<HashMap> nmprList = goodsService.getGoodsNmprList(map);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("cart_sn", cart_sn);

        model.addAttribute("result", result);
        model.addAttribute("clList", clList);
        model.addAttribute("schdulList", schdulList);
        model.addAttribute("nmprList", nmprList);

        return "gnrl/cart/detail";
    }


    @RequestMapping(value="/addAction/")
    public void addAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
        
        String goods_code = SimpleUtils.default_set(request.getParameter("hidGoodsCode"));
        String rdoNmprCnd = SimpleUtils.default_set(request.getParameter("rdoNmprCnd"));
        String txtDate = SimpleUtils.default_set(request.getParameter("txtDate"));
    
    	HashMap map = new HashMap();
    	map.put("goods_code", goods_code);
    	map.put("nmpr_sn", rdoNmprCnd);
    	map.put("tour_de", txtDate.replace("-",""));
    	map.put("esntl_id", esntl_id);

    	//상품조건이 맞는지 확인
    	HashMap result = cartService.getCartValidCnfirm(map);
    	if(result != null){
        	cartService.addCart(map); 		
    	}
    	response.sendRedirect("/goods/detail/?hidGoodsCode="+goods_code);
    }

    @RequestMapping(value="/updateAction/")
    public void updateAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		response.sendRedirect("/cart/list/");
	}

    @RequestMapping(value="/deleteAction/")
    public void deleteAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		response.sendRedirect("/cart/list/");
	}

}
