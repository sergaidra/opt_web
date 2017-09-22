package kr.co.siione.gnrl.cart.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cart.service.FlightService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/cart/")
public class CartController2 {

	@Resource
	private GoodsService goodsService;

	@Resource
	private CartService cartService;
	
	@Resource
	private FlightService flightService;

	@Resource
	private ArprtManageService arprtManageService;

	private static final Logger LOG = LoggerFactory.getLogger(CartController.class);
	
	@RequestMapping(value="/addAction/")
	public ResponseEntity<String> addAction(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();
		UserUtils.log("[addCart-param]", param);

		try { 
		
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";
		String retMessage = "";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			String goods_code = UserUtils.nvl(param.get("hidGoodsCode"));
			String purchs_amount = UserUtils.nvl(param.get("PURCHS_AMOUNT").replaceAll(",", "").replaceAll("₩", ""));
			
			// 일반상품
			String tour_de = UserUtils.nvl(param.get("TOUR_DE")).replaceAll("-", "");
			String tour_time = UserUtils.nvl(param.get("TOUR_TIME"));
			
			// 숙박
			String chkin_de = UserUtils.nvl(param.get("CHKIN_DE")).replaceAll("-", "");
			String chckt_de = UserUtils.nvl(param.get("CHCKT_DE")).replaceAll("-", "");
			
			String[] arrSetupSe = request.getParameterValues("SETUP_SE");
			String[] arrNmprSn = request.getParameterValues("NMPR_SN");
			String[] arrCartNmprCo = request.getParameterValues("CART_NMPR_CO");
			
			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< arrSetupSe.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("setup_se", arrSetupSe[i]);
				nmap.put("nmpr_sn", arrNmprSn[i]);
				nmap.put("nmpr_co", arrCartNmprCo[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(arrCartNmprCo[i]) && Integer.parseInt(arrCartNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}
			

			/*String hidStayngFcltyAt = UserUtils.nvl(param.get("hidStayngFcltyAt"), "N");
			String hidChkinDe = UserUtils.nvl(param.get("hidChkinDe"));
			String hidChcktDe = UserUtils.nvl(param.get("hidChcktDe"));

			String hidWaitTime = UserUtils.nvl(param.get("hidWaitTime"));
			String hidMvmnTime = UserUtils.nvl(param.get("hidMvmnTime"));

			String[] hidNmprCo = request.getParameterValues("hidNmprCo");
			String[] hidNmprSn = request.getParameterValues("hidNmprSn");

			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< hidNmprCo.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("nmpr_co", hidNmprCo[i]);
				nmap.put("nmpr_sn", hidNmprSn[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(hidNmprCo[i]) && Integer.parseInt(hidNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}*/

			HashMap map = new HashMap();
			map.put("opert_se", "I");			
			map.put("esntl_id", esntl_id);			
			map.put("goods_code", goods_code);
			map.put("purchs_amount", purchs_amount);
			map.put("tour_de", tour_de);
			map.put("chkin_de", chkin_de);
			map.put("chckt_de", chckt_de);
			map.put("nmpr_list", nmprList);
			if(tour_time.length() == 8) {
				map.put("begin_time", tour_time.substring(0, 4));
				map.put("end_time", tour_time.substring(4, 8));
			} else {
				map.put("begin_time", "");
				map.put("end_time", "");
			}

			UserUtils.log("[addCard-map]", map);
			
			cartService.addCart(map);
			retValue = "0";
		}
		
		LOG.debug("[addCard]retValue:"+retValue);
		LOG.debug("[addCard]retMessage:"+retMessage);
		obj.put("result", retValue);
		obj.put("message", retMessage);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		} catch(Exception e) {e.printStackTrace();}
		
		return entity;
	}

	@RequestMapping(value="/modAction/")
	public ResponseEntity<String> modAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";
		String retMessage = "";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		
		UserUtils.log("[modCard]param:", param);

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			String cart_sn = UserUtils.nvl(request.getParameter("hidCartSn"));
			String goods_code = UserUtils.nvl(request.getParameter("hidGoodsCode"));
			String tour_de = UserUtils.nvl(request.getParameter("TOUR_DE"));
			String hidTime = UserUtils.nvl(request.getParameter("TOUR_TIME"));

			String hidChkinDe = UserUtils.nvl(request.getParameter("CHKIN_DE"));
			String hidChcktDe = UserUtils.nvl(request.getParameter("CHCKT_DE"));

			String hidWaitTime = UserUtils.nvl(request.getParameter("hidWaitTime"));
			String hidMvmnTime = UserUtils.nvl(request.getParameter("hidMvmnTime"));

			String[] selNmprCo = request.getParameterValues("selNmprCo");
			String[] hidNmprSn = request.getParameterValues("hidNmprSn");

			List<HashMap> nmprList = new ArrayList<HashMap>();
			for(int i=0;i< selNmprCo.length;i++){
				HashMap nmap = new HashMap();
				nmap.put("nmpr_co", selNmprCo[i]);
				nmap.put("nmpr_sn", hidNmprSn[i]);

				//인원수가 0보다 크면 추가
				if(SimpleUtils.isStringInteger(selNmprCo[i]) && Integer.parseInt(selNmprCo[i]) > 0){
					nmprList.add(nmap);
				}
			}

			HashMap map = new HashMap();
			map.put("opert_se", "U");
			map.put("cart_sn", cart_sn);
			map.put("goods_code", goods_code);
			map.put("nmpr_list", nmprList);
			map.put("tour_de", tour_de.replace("-",""));
			map.put("chkin_de", hidChkinDe.replace("-",""));
			map.put("chckt_de", hidChcktDe.replace("-",""));
			map.put("esntl_id", esntl_id);
			if(hidTime.length() == 8) {
				map.put("begin_time", hidTime.substring(0, 4));
				map.put("end_time", hidTime.substring(4, 8));
			} else {
				map.put("begin_time", "");
				map.put("end_time", "");
			}

			cartService.updateCart(map);
			retValue = "0";
			
		}

		LOG.debug("[modCard]retValue:"+retValue);
		LOG.debug("[modCard]retMessage:"+retMessage);
		obj.put("result", retValue);
		obj.put("message", retMessage);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	
}