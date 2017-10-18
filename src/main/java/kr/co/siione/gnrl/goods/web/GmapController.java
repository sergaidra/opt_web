package kr.co.siione.gnrl.goods.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class GmapController {
    
	protected Log log = LogFactory.getLog(this.getClass());
	
	@RequestMapping(value="/gmap/location/")
	public String gmap(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {

		UserUtils.log("[gmap]", param);

		model.addAttribute("la", UserUtils.nvl(param.get("la"), "48.874089"));
		model.addAttribute("lo", UserUtils.nvl(param.get("lo"), "2.295122"));

		log.debug("[gmap-model] "+model);

		return "/gmap/gmapMarker";
	}

	@RequestMapping(value="/gmap/gmap2/")
	public String gmap2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/bak/gmapMarker";
	}

	@RequestMapping(value="/gmap/gmap3/")
	public String gmap3(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/gmap/gmapDataLoad";
	}    
}