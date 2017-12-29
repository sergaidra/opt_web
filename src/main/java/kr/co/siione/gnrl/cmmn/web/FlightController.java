package kr.co.siione.gnrl.cmmn.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cart.service.FlightService2;
import kr.co.siione.gnrl.cmmn.service.FlightService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/cmmn/")
public class FlightController {

	@Resource
	private FlightService flightService;
	
	@Resource
	private ArprtManageService arprtManageService;

	private static final Logger LOG = LoggerFactory.getLogger(FlightController.class);
	
    @RequestMapping(value="/popupFlight")
    public String popupFlight(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		try {
	    	HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
			String callback = UserUtils.nvl(request.getParameter("callback"));		

			if(!esntl_id.isEmpty()){
				HashMap map = new HashMap();
		    	map.put("esntl_id", esntl_id);
		    	
		    	HashMap result = flightService.selectLastFlight(map);
		    	
		    	if(result != null) {
		    		if(result.get("DTRMC_START_DT") != null) {
		    			String [] dt = String.valueOf(result.get("DTRMC_START_DT")).split("[\\- ]");
		    			if(dt.length == 4) {
		    				result.put("DTRMC_START_YEAR", dt[0]);
		    				result.put("DTRMC_START_MONTH", dt[1]);
		    				result.put("DTRMC_START_DAY", dt[2]);
		    				result.put("DTRMC_START_TIME", dt[3]);
		    			}
		    		}
		    		if(result.get("DTRMC_ARVL_DT") != null) {
		    			String [] dt = String.valueOf(result.get("DTRMC_ARVL_DT")).split("[\\- ]");
		    			if(dt.length == 4) {
		    				result.put("DTRMC_ARVL_YEAR", dt[0]);
		    				result.put("DTRMC_ARVL_MONTH", dt[1]);
		    				result.put("DTRMC_ARVL_DAY", dt[2]);
		    				result.put("DTRMC_ARVL_TIME", dt[3]);
		    			}
		    		}
		    		if(result.get("HMCMG_START_DT") != null) {
		    			String [] dt = String.valueOf(result.get("HMCMG_START_DT")).split("[\\- ]");
		    			if(dt.length == 4) {
		    				result.put("HMCMG_START_YEAR", dt[0]);
		    				result.put("HMCMG_START_MONTH", dt[1]);
		    				result.put("HMCMG_START_DAY", dt[2]);
		    				result.put("HMCMG_START_TIME", dt[3]);
		    			}
		    		}
		    		if(result.get("HMCMG_ARVL_DT") != null) {
		    			String [] dt = String.valueOf(result.get("HMCMG_ARVL_DT")).split("[\\- ]");
		    			if(dt.length == 4) {
		    				result.put("HMCMG_ARVL_YEAR", dt[0]);
		    				result.put("HMCMG_ARVL_MONTH", dt[1]);
		    				result.put("HMCMG_ARVL_DAY", dt[2]);
		    				result.put("HMCMG_ARVL_TIME", dt[3]);
		    			}
		    		}
		    	}
		    	
	    		model.addAttribute("result", result);
			}
			
    		HashMap map2 = new HashMap();
    		map2.put("USE_AT", "Y");
    		List<Map<String, String>> lstFlight = arprtManageService.selectArprtList(map2);
    		List<Integer> lstYear = new ArrayList();
    		int todayYear = Calendar.getInstance().get(Calendar.YEAR);
    		for(int i = 0; i < 5; i++)
    			lstYear.add(todayYear + i);
    		
    		model.addAttribute("lstFlight", lstFlight);
    		model.addAttribute("lstYear", lstYear);
    		model.addAttribute("callback", callback);

		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return "gnrl/popup/flight";	
    }	

    @RequestMapping(value="/getCurrentFlight")
    public @ResponseBody ResponseVo getCurrentFlight(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
	    	HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			HashMap map = new HashMap();
	    	map.put("esntl_id", esntl_id);
	    	
	    	List lst = flightService.selectCurrentFlight(map);
	    	resVo.setData(lst);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }

    @RequestMapping(value="/saveFlight")
    public @ResponseBody ResponseVo saveFlight(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
	    	HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			HashMap map = new HashMap();
	    	map.put("esntl_id", esntl_id);
	    	map.put("flight_sn", UserUtils.nvl(param.get("flight_sn")));
	    	map.put("dtrmc_flight", UserUtils.nvl(param.get("dtrmc_flight")));
	    	map.put("dtrmc_start_arprt_code", UserUtils.nvl(param.get("dtrmc_start_arprt_code")));
	    	map.put("dtrmc_start_cty", UserUtils.nvl(param.get("dtrmc_start_cty")));
	    	map.put("dtrmc_start_dt", UserUtils.nvl(param.get("dtrmc_start_dt")));
	    	map.put("dtrmc_arvl_arprt_code", UserUtils.nvl(param.get("dtrmc_arvl_arprt_code")));
	    	map.put("dtrmc_arvl_cty", UserUtils.nvl(param.get("dtrmc_arvl_cty")));
	    	map.put("dtrmc_arvl_dt", UserUtils.nvl(param.get("dtrmc_arvl_dt")));	    	
	    	map.put("hmcmg_flight", UserUtils.nvl(param.get("hmcmg_flight")));
	    	map.put("hmcmg_start_arprt_code", UserUtils.nvl(param.get("hmcmg_start_arprt_code")));
	    	map.put("hmcmg_start_cty", UserUtils.nvl(param.get("hmcmg_start_cty")));
	    	map.put("hmcmg_start_dt", UserUtils.nvl(param.get("hmcmg_start_dt")));
	    	map.put("hmcmg_arvl_arprt_code", UserUtils.nvl(param.get("hmcmg_arvl_arprt_code")));
	    	map.put("hmcmg_arvl_cty", UserUtils.nvl(param.get("hmcmg_arvl_cty")));
	    	map.put("hmcmg_arvl_dt", UserUtils.nvl(param.get("hmcmg_arvl_dt")));

	    	flightService.insertFlight(map);

	    	resVo.setData(map.get("flight_sn"));

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }
    
    @RequestMapping(value="/initFlight")
    public @ResponseBody ResponseVo initFlight(HttpServletRequest request, HttpServletResponse response, @RequestBody HashMap param) throws Exception {
		ResponseVo resVo = new ResponseVo();
		resVo.setResult("-1");
		resVo.setMessage("");

		try {
	    	HttpSession session = request.getSession();
			String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));

			if(esntl_id.isEmpty()){
				resVo.setResult("-2");
				return resVo;
			}

			HashMap map = new HashMap();
	    	map.put("esntl_id", esntl_id);

	    	flightService.initFlight(map);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	
    }

}
