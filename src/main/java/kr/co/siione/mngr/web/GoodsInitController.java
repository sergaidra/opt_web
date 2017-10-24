package kr.co.siione.mngr.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.mngr.service.GoodsInitService;
import kr.co.siione.utl.UserUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Controller
public class GoodsInitController {
	
	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	@Resource(name = "GoodsInitService")
	private GoodsInitService goodsInitService;

	
	@RequestMapping(value="/mngr/GoodsDtaInit/")
	public String GoodsInitDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/mngr/GoodsDtaInit";
	}

	@RequestMapping(value="/mngr/selectDtaInitList/")
	public void selectGoodsListForSearch(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception  {
		List<Map<String,String>> results = null;

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			results = goodsInitService.selectDtaInitList(param);

			result.put("rows", results.size());
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
	
	@RequestMapping(value="/mngr/initGoodsDta/")
	public void initGoodsDta(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
		param.put("INIT_ID", esntl_id);
		
		UserUtils.log("[initGoodsDta]param", param);
		
		try {
			int iRe = goodsInitService.initGoodsDta(param);

			if(iRe > 0) {
				result.put("success", true);
				result.put("message", "자료초기화 성공");
			} else {
				result.put("success", false);
				result.put("message", "자료초기화 실패");
			}
		}  catch (Exception e) {
			log.error(e.getLocalizedMessage());
			result.put("success", false);
			result.put("error"  , e.getMessage());
		}

		jsonView.render(result, request, response);
	}
}