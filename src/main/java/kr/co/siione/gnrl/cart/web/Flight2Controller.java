package kr.co.siione.gnrl.cart.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cart.service.FlightService2;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.mngr.service.ArprtManageService;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/cart/")
public class Flight2Controller {

	@Resource
	private GoodsService goodsService;

	@Resource
	private FlightService2 flightService;

	@Resource
	private ArprtManageService arprtManageService;

	private static final Logger LOG = LoggerFactory.getLogger(Flight2Controller.class);

	@RequestMapping(value="/flightPopup/")
	public String flight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		
		List<Map<String, String>> list = null;

		if(esntl_id.isEmpty()){
			retValue = "-2";
		} else {
			map = flightService.getFlightDetail(map);
			list = arprtManageService.selectArprtList(map);
		}

		model.addAttribute("flight", map);
		model.addAttribute("arprtList", list);

		return "gnrl/cart/flight";
	}


	@RequestMapping(value="/addFlightAction/")
	public ResponseEntity<String> addFlightAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
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
			param.put("ESNTL_ID", esntl_id);
			flightService.addFlight(param);
			retValue = "0";
		}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	@RequestMapping(value="/modFlightAction/")
	public ResponseEntity<String> modFlightAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String flight_sn = UserUtils.nvl(param.get("FLIGHT_SN"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else if(flight_sn.equals("") || flight_sn == null){
			retValue = "-1";
		}else{
			param.put("ESNTL_ID", esntl_id);
			flightService.updateFlight(param);

			retValue = "0";
		}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}
	
	@RequestMapping(value="/delFlightAction/")
	public ResponseEntity<String> delFlightAction(HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();

		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		String flight_sn = UserUtils.nvl(param.get("FLIGHT_SN"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else if(flight_sn.equals("") || flight_sn == null){
			retValue = "-1";
		}else{
			param.put("ESNTL_ID", esntl_id);
			flightService.deleteFlight(param);

			retValue = "0";
		}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}	

	@RequestMapping(value="/getFlightAction/")
	public ResponseEntity<String> getFilightAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
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

			map = flightService.getFlightDetail(map);
			obj.put("flight", map);

			retValue = "0";
		}

		obj.put("result", retValue);
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

	@RequestMapping(value="/getArlineSchdulAction/")
	public ResponseEntity<String> getArlineSchdul(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
		ResponseEntity<String> entity = null;
		JSONObject obj = new JSONObject();
		List<HashMap> arlineSchdulList = null;
		
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type","text/plain; charset=utf-8");

		String retValue = "-1";

		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

		if(esntl_id.isEmpty()){
			retValue = "-2";
		}else{
 			arlineSchdulList = flightService.getArlineSchdulList(param);
 			retValue = "0";
		}

		obj.put("arlineSchdulList", arlineSchdulList);
		obj.put("result", retValue);
	
		System.out.println("flight_obj::"+obj);
		
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}

}
