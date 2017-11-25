package kr.co.siione.gnrl.cmmn.web;

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

	private static final Logger LOG = LoggerFactory.getLogger(FlightController.class);

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

}
