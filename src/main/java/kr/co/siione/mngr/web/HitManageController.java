package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.FileManageService;
import kr.co.siione.mngr.service.HitManageService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class HitManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "HitManageService")
	private HitManageService hitManageService;

	@RequestMapping(value="/mngr/GoodsHitManage/")
	public String GoodsHitManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		if(esntl_id.equals("")) response.sendRedirect("/member/login/");
		
		return "/mngr/GoodsHitManage";
	}

	@RequestMapping(value="/mngr/selectGoodsHitList/")
	public void selectGoodsHitList(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = hitManageService.selectGoodsHitListCount(param);
			List<Map<String,String>> results = hitManageService.selectGoodsHitList(param);

			result.put("rows", cnt);
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}

	@RequestMapping(value="/mngr/selectGoodsHitStatsDay/")
	public void selectGoodsHitStatsDay(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = hitManageService.selectGoodsHitListCount(param);
			List<Map<String,String>> results = hitManageService.selectGoodsHitStatsDay(param);

			result.put("rows", cnt);
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}
		
	@RequestMapping(value="/mngr/selectGoodsHitStatsMonth/")
	public void selectGoodsHitStatsMonth(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		Map<String, Object> result = new HashMap<String, Object>();
		UserUtils.log(param);
		try {
			int cnt = hitManageService.selectGoodsHitListCount(param);
			List<Map<String,String>> results = hitManageService.selectGoodsHitStatsMonth(param);

			result.put("rows", cnt);
			result.put("data", results);
			result.put("success", true);
		} catch (Exception e) {
			log.error(e.getMessage());
			result.put("message", e.getMessage());
			result.put("success", false);
		} finally {
			jsonView.render(result, request, response);
		}
	}
}