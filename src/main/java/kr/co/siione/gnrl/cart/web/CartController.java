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
public class CartController {

	@Resource
	private GoodsService goodsService;

	@Resource
	private CartService cartService;
	
	@Resource
	private FlightService flightService;

	@Resource
	private ArprtManageService arprtManageService;

	private static final Logger LOG = LoggerFactory.getLogger(CartController.class);

	@RequestMapping(value="/cart_list_page/")
	public String cart_list_page(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		//현재 페이지 파라메타
		String hidPage = UserUtils.nvl(request.getParameter("hidPage"));
		int intPage = 1;
		if(!hidPage.equals(""))
			intPage = Integer.parseInt((String)hidPage);

		//페이지 기본설정
		int pageBlock = 6;
		int pageArea = 10;


		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		long payment = cartService.getCartPayment(map);

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

		model.addAttribute("payCount", list_cnt);
		model.addAttribute("payment", payment);

		return "gnrl/cart/cart_list_page";
	}
	
	@RequestMapping(value="/list/")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		try {
		
		long payment = cartService.getCartPayment(map);

		int list_cnt = 0;

		map.put("SEARCH_SE", "A");
		List<HashMap> actList = cartService.getCartListBySearchSe(map);
		if(actList.size() > 0){
			list_cnt += Integer.parseInt(actList.get(0).get("TOT_CNT").toString());
		}
		
		map.put("SEARCH_SE", "S");
		List<HashMap> stayngList = cartService.getCartListBySearchSe(map);
		if(stayngList.size() > 0){
			list_cnt += Integer.parseInt(stayngList.get(0).get("TOT_CNT").toString());
		}

		model.addAttribute("actList", actList);
		model.addAttribute("stayngList", stayngList);
		
		model.addAttribute("payCount", list_cnt);
		model.addAttribute("payment", payment);
		
		} catch(Exception e) {e.printStackTrace();}

		return "gnrl/cart/list";
	}


	@RequestMapping(value="/detail/")
	public String detail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String cart_sn = UserUtils.nvl(request.getParameter("hidCartSn"));
		String hidPage = UserUtils.nvl(request.getParameter("hidPage"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		map.put("cart_sn", cart_sn);
		HashMap result = cartService.getCartDetail(map);

		String goods_code = (String) result.get("GOODS_CODE");

		map.put("goods_code", goods_code);
		List<HashMap> nmprList = cartService.getCartNmprList(map);
		//List<HashMap> clList = goodsService.getGoodsClList(map);
		List<HashMap> schdulList = goodsService.getGoodsSchdulList(map);
		List<HashMap> timeList = goodsService.getGoodsTimeList(map);

		String stayngFcltyAt = "N";
//		for(HashMap clMap : clList) {
//			if(UserUtils.nvl(clMap.get("STAYNG_FCLTY_AT")).equals("Y")) {
//				stayngFcltyAt = "Y";
//				break;
//			}
//		}

		model.addAttribute("stayngFcltyAt", stayngFcltyAt);

		model.addAttribute("hidPage", hidPage);
		model.addAttribute("cart_sn", cart_sn);

		model.addAttribute("result", result);
		//model.addAttribute("clList", clList);
		model.addAttribute("schdulList", schdulList);
		model.addAttribute("nmprList", nmprList);
		model.addAttribute("timeList", timeList);

		return "gnrl/cart/detail";
	}

	@RequestMapping(value="/addAction/")
	public ResponseEntity<String> addAction(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();
		UserUtils.log("[addCart-param]", param);

/*		[addCart-param] ==================== log start ==============================
		[addCart-param] hidPage             : 
		[addCart-param] hidGoodsCode        : 0000000092
		[addCart-param] hidUpperClCode      : 00042
		[addCart-param] hidUpperClCodeNavi  : 00042@
		[addCart-param] hidStayngFcltyAt    : N
		[addCart-param] hidWaitTime         : 0000
		[addCart-param] hidMvmnTime         : 0000
		[addCart-param] txtDate             : 2017-09-26
		[addCart-param] selTime             : 05201540
		[addCart-param] txtTime             : 시간을 선택하세요
		[addCart-param] hidTime             : 
		[addCart-param] hidNmprCo           : 2
		[addCart-param] hidNmprSn           : 1
		[addCart-param] txtPay              : ₩310,000
		[addCart-param] ==================== log end ================================		
*/		
/*		[addCart-param] ==================== log start ==============================
		[addCart-param] hidPage             :
		[addCart-param] hidGoodsCode        : 0000000002
		[addCart-param] hidUpperClCode      : 00005@00002@00004@00003@
		[addCart-param] hidStayngFcltyAt    : Y
		[addCart-param] hidChkinDe          : 2017-08-21
		[addCart-param] hidChcktDe          : 2017-08-31
		[addCart-param] txtDateRange        : {"start":"2017-08-21","end":"2017-08-31"}
		[addCart-param] txtDateCount        : 10박
		[addCart-param] hidNmprCo           : 2
		[addCart-param] hidPayment          : 120000
		[addCart-param] hidNmprSn           : 1
		[addCart-param] txtPay              : ₩ 2400000
		[addCart-param] ==================== log end ================================*/


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
			String txtDate = UserUtils.nvl(param.get("txtDate"));
			String selTime = UserUtils.nvl(param.get("selTime"));

			String hidStayngFcltyAt = UserUtils.nvl(param.get("hidStayngFcltyAt"), "N");
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
			}

			HashMap map = new HashMap();
			map.put("opert_se", "I");
			map.put("goods_code", goods_code);
			map.put("nmpr_list", nmprList);
			map.put("stayng_fclty_at", hidStayngFcltyAt);
			map.put("tour_de", txtDate.replace("-",""));
			map.put("chkin_de", hidChkinDe.replace("-",""));
			map.put("chckt_de", hidChcktDe.replace("-",""));
			map.put("esntl_id", esntl_id);
			if(selTime.length() == 8) {
				map.put("begin_time", selTime.substring(0, 4));
				map.put("end_time", selTime.substring(4, 8));
			} else {
				map.put("begin_time", "");
				map.put("end_time", "");
			}

			UserUtils.log("[addCard-map]", map);
			
			cartService.addCart(map);
			retValue = "0";
			
			
/*			[addCard-map] ==================== log start ==============================
			[addCard-map] chckt_de            : 
			[addCard-map] chkin_de            : 
			[addCard-map] nmpr_list           : [{nmpr_co=2, nmpr_sn=1}]
			[addCard-map] begin_time          : 
			[addCard-map] tour_de             : 20170926
			[addCard-map] end_time            : 
			[addCard-map] goods_code          : 0000000092
			[addCard-map] opert_se            : I
			[addCard-map] stayng_fclty_at     : N
			[addCard-map] esntl_id            : GNRL0000000000000081
			[addCard-map] ==================== log end ================================			
*/			
/*			[addCard-map] ==================== log start ==============================
			[addCard-map] chckt_de            :
			[addCard-map] chkin_de            :
			[addCard-map] nmpr_list           : [{nmpr_co=2, nmpr_sn=1}]
			[addCard-map] begin_time          : 0900
			[addCard-map] tour_de             : 20170714
			[addCard-map] end_time            : 1600
			[addCard-map] goods_code          : 0000000022
			[addCard-map] esntl_id            : GNRL0000000000000081
			[addCard-map] ==================== log end ================================*/
/*			[addCard-map] ==================== log start ==============================
			[addCard-map] chckt_de            : 20170831
			[addCard-map] chkin_de            : 20170821
			[addCard-map] nmpr_list           : [{nmpr_co=2, nmpr_sn=1}]
			[addCard-map] begin_time          :
			[addCard-map] tour_de             :
			[addCard-map] end_time            :
			[addCard-map] goods_code          : 0000000002
			[addCard-map] esntl_id            : GNRL0000000000000081
			[addCard-map] ==================== log end ================================*/
			
			// 2017-09-14 일정체크 안함
			/* 숙박
			if(UserUtils.nvl(param.get("hidStayngFcltyAt")).equals("Y")) {
				// 상품조건이 맞는지 확인
				HashMap mapGoods = cartService.getCartValidCnfirm(map); // 일정
				LOG.debug("[addCard][숙박-일정]mapGoods:"+mapGoods);
				if(mapGoods == null) {
					retValue = "9";
					retMessage = "선택한 날짜에 예약이 불가능합니다.";
				} else {
					// 비행일정 체크
					HashMap mapFlight  = cartService.getCartFlightValidCnfirm(map);
					LOG.debug("[addCard][숙박-비행]mapFlight:"+mapFlight);
					if(mapFlight == null) {
						retValue = "9";
						retMessage = "비행일정에 해당 일정이 포함되지 않습니다.";
					} else {
						// 중복일정 체크
						List listStayng = cartService.getCartStayngValidCnfirm(map);
						LOG.debug("[addCard][숙박-중복]listStayng:"+listStayng);
						if(listStayng.size() > 0) {
							retValue = "9";
							retMessage = "일정이 중복되어 예약할 수 없습니다.";
						} else {
							// 숙박시설 장바구니 담기 체크 조건
							//if(mapGoods != null && mapFlight != null && listStayng == null)
							cartService.addCart(map);
							retValue = "0";
						}
					}
				}
			} else { // 상품
				// 동일상품 확인
				List listSame = cartService.getCartSameValidCnfirm(map);
				if(listSame.size() > 0) {
					retValue = "9";
					retMessage = "동일한 상품이 존재합니다. 장바구니에서 수정하시기 바랍니다.";
				} else {
					// 상품조건이 맞는지 확인
					HashMap mapGoods  = cartService.getCartValidCnfirm(map); // 일정
					LOG.debug("[addCard][상품-일정]mapGoods:"+mapGoods);
					if(mapGoods == null) {
						retValue = "9";
						retMessage = "선택한 날짜에 예약이 불가능합니다.";
					} else {
						HashMap mapTime = cartService.getCartTimeValidCnfirm(map); // 시간
						LOG.debug("[addCard][상품-시간]mapTime:"+mapTime);
						if(mapTime == null) {
							retValue = "9";
							retMessage = "선택한 시간에 예약이 불가능합니다.";
						} else {
							// 비행일정 체크
							HashMap mapFlight = cartService.getCartFlightValidCnfirm(map);
							LOG.debug("[addCard][상품-비행일정]mapFlight:"+mapFlight);
							if(mapFlight == null) {
								retValue = "9";
								retMessage = "비행일정에 해당 일정이 포함되지 않습니다.";
							} else {
								// 중복일정 체크
								String b_time = map.get("begin_time").toString();
								String e_time = map.get("end_time").toString();
								String w_time = hidWaitTime;
								String m_time = hidMvmnTime;

								double d_b_time = (Integer.parseInt(b_time.substring(0, 2)) - Integer.parseInt(w_time.substring(0, 2))) + ((Integer.parseInt(b_time.substring(2, 4)) - Integer.parseInt(w_time.substring(2, 4))) / 60.0);
								double b_e_time = (Integer.parseInt(e_time.substring(0, 2)) + Integer.parseInt(m_time.substring(0, 2))) + ((Integer.parseInt(e_time.substring(2, 4)) + Integer.parseInt(m_time.substring(2, 4))) / 60.0);

								String str1 = StringUtils.leftPad(String.valueOf((int)Math.floor(d_b_time)), 2, "0");
								String str2 = StringUtils.leftPad(String.valueOf((int)((d_b_time - Math.floor(d_b_time)) * 60)), 2, "0");
								String str3 = StringUtils.leftPad(String.valueOf((int)Math.floor(b_e_time)), 2, "0");
								String str4 = StringUtils.leftPad(String.valueOf((int)((b_e_time - Math.floor(b_e_time)) * 60)), 2, "0");

								map.put("real_begin_time", str1+str2);
								map.put("real_end_time", str3+str4);

								List listDplct = cartService.getCartDplctValidCnfirm(map);
								LOG.debug("[addCard][상품-일정중복]listDplct:"+listDplct);
								if(listDplct.size() > 0) {
									retValue = "9";
									retMessage = "일정이 중복되어 예약할 수 없습니다.";
								} else {
									// 상품 장바구니 담기 체크 조건
									//if(listSame == null && mapGoods != null && mapTime != null && mapFlight != null && mapDplct == null)
									cartService.addCart(map);
									retValue = "0";
								}
							}
						}
					}
				}
			}*/
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
			String txtDate = UserUtils.nvl(request.getParameter("txtDate"));
			String hidTime = UserUtils.nvl(request.getParameter("hidTime"));

			String hidStayngFcltyAt = UserUtils.nvl(request.getParameter("hidStayngFcltyAt"), "N");
			String hidChkinDe = UserUtils.nvl(request.getParameter("hidChkinDe"));
			String hidChcktDe = UserUtils.nvl(request.getParameter("hidChcktDe"));

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
			map.put("stayng_fclty_at", hidStayngFcltyAt);
			map.put("tour_de", txtDate.replace("-",""));
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
			
			/* 2017-09-14 일정체크 안함
			// 숙박
			if(UserUtils.nvl(request.getParameter("hidStayngFcltyAt")).equals("Y")) {
				// 상품조건이 맞는지 확인
				HashMap mapGoods = cartService.getCartValidCnfirm(map); // 일정
				LOG.debug("[modCart][숙박-일정]mapGoods:"+mapGoods);
				if(mapGoods == null) {
					retValue = "9";
					retMessage = "선택한 날짜에 예약이 불가능합니다.";
				} else {
					// 비행일정 체크
					HashMap mapFlight  = cartService.getCartFlightValidCnfirm(map);
					LOG.debug("[modCart][숙박-비행]mapFlight:"+mapFlight);
					if(mapFlight == null) {
						retValue = "9";
						retMessage = "비행일정에 해당 일정이 포함되지 않습니다.";
					} else {
						// 중복일정 체크
						List listStayng = cartService.getCartStayngValidCnfirm(map);
						LOG.debug("[modCart][숙박-중복]listStayng:"+listStayng);
						if(listStayng.size() > 0) {
							retValue = "9";
							retMessage = "일정이 중복되어 예약할 수 없습니다.";
						} else {
							// 숙박시설 장바구니 담기 체크 조건
							//if(mapGoods != null && mapFlight != null && listStayng == null)
							cartService.updateCart(map);
							retValue = "0";
						}
					}
				}
			} else { // 상품
				// 상품조건이 맞는지 확인
				HashMap mapGoods  = cartService.getCartValidCnfirm(map); // 일정
				LOG.debug("[modCart][상품-일정]mapGoods:"+mapGoods);
				if(mapGoods == null) {
					retValue = "9";
					retMessage = "선택한 날짜에 예약이 불가능합니다.";
				} else {
					HashMap mapTime = cartService.getCartTimeValidCnfirm(map); // 시간
					LOG.debug("[modCart][상품-시간]mapTime:"+mapTime);
					if(mapTime == null) {
						retValue = "9";
						retMessage = "선택한 시간에 예약이 불가능합니다.";
					} else {
						// 비행일정 체크
						HashMap mapFlight = cartService.getCartFlightValidCnfirm(map);
						LOG.debug("[modCart][상품-비행일정]mapFlight:"+mapFlight);
						if(mapFlight == null) {
							retValue = "9";
							retMessage = "비행일정에 해당 일정이 포함되지 않습니다.";
						} else {
							// 중복일정 체크
							String b_time = map.get("begin_time").toString();
							String e_time = map.get("end_time").toString();
							String w_time = hidWaitTime;
							String m_time = hidMvmnTime;
							
							double d_b_time = (Integer.parseInt(b_time.substring(0, 2)) - Integer.parseInt(w_time.substring(0, 2))) + ((Integer.parseInt(b_time.substring(2, 4)) - Integer.parseInt(w_time.substring(2, 4))) / 60.0);
							double b_e_time = (Integer.parseInt(e_time.substring(0, 2)) + Integer.parseInt(m_time.substring(0, 2))) + ((Integer.parseInt(e_time.substring(2, 4)) + Integer.parseInt(m_time.substring(2, 4))) / 60.0);

							String str1 = StringUtils.leftPad(String.valueOf((int)Math.floor(d_b_time)), 2, "0");
							String str2 = StringUtils.leftPad(String.valueOf((int)((d_b_time - Math.floor(d_b_time)) * 60)), 2, "0");
							String str3 = StringUtils.leftPad(String.valueOf((int)Math.floor(b_e_time)), 2, "0");
							String str4 = StringUtils.leftPad(String.valueOf((int)((b_e_time - Math.floor(b_e_time)) * 60)), 2, "0");

							map.put("real_begin_time", str1+str2);
							map.put("real_end_time", str3+str4);

							List listDplct = cartService.getCartDplctValidCnfirm(map);
							LOG.debug("[modCart][상품-일정중복]listDplct:"+listDplct);
							if(listDplct.size() > 0) {
								retValue = "9";
								retMessage = "일정이 중복되어 예약할 수 없습니다.";
							} else {
								// 상품 장바구니 담기 체크 조건
								//if(listSame == null && mapGoods != null && mapTime != null && mapFlight != null && mapDplct == null)
								cartService.updateCart(map);
								retValue = "0";
							}
						}
					}
				}
			}*/
		}

		LOG.debug("[modCard]retValue:"+retValue);
		LOG.debug("[modCard]retMessage:"+retMessage);
		obj.put("result", retValue);
		obj.put("message", retMessage);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	@RequestMapping(value="/delAction/")
	public void delAction(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String cart_sn = UserUtils.nvl(request.getParameter("hidCartSn"));

		HashMap map = new HashMap();
		map.put("cart_sn", cart_sn);
		map.put("esntl_id", esntl_id);
		cartService.deleteCart(map);

		response.sendRedirect("/cart/list/");
	}

	@RequestMapping(value="/getAction/")
	public ResponseEntity<String> getAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
			HashMap map = new HashMap();
			map.put("esntl_id", esntl_id);

			List<HashMap> cartList = cartService.getCartListForSchedule(map);
			obj.put("cartList", cartList);

			retValue = "0";
		}

		obj.put("result", retValue);
		System.out.println("cart_obj:"+obj);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	// 일정표를 calender 형식으로 보여 줌.
	@RequestMapping(value="/calendarPopup/")
	public String calendar(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "gnrl/cart/calendar";
	}

	@RequestMapping(value="/bannerAction/")
	public String banner(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "gnrl/cart/banner";
	}

	@RequestMapping(value="/schedulePopup/")
	public String schedule(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);

		HashMap flight = flightService.getFlightDetail(map);
		List<HashMap> cartList = cartService.getCartListForSchedule(map);

		model.addAttribute("flight", flight);
		model.addAttribute("cartList", cartList);

		return "gnrl/cart/schedule";
	}	
}