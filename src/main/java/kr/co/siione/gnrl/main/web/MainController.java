package kr.co.siione.gnrl.main.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.gnrl.cmmn.service.FlightService;
import kr.co.siione.gnrl.cmmn.vo.ResponseVo;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.NoticeService;
import kr.co.siione.gnrl.goods.service.GoodsService;
import kr.co.siione.gnrl.main.service.MainService;
import kr.co.siione.gnrl.main.vo.ScheduleDateVo;
import kr.co.siione.gnrl.main.vo.ScheduleTimeVo;
import kr.co.siione.gnrl.mber.service.LoginService;
import kr.co.siione.utl.UserUtils;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

@Controller
@RequestMapping(value = "/main/")
public class MainController {
    
	@Resource
    private GoodsService goodsService;

	@Resource
    private MainService mainService;
	
	@Resource
    private LoginService loginService;

	@Resource
    private NoticeService noticeService;

	@Resource
	private LiveViewService liveViewService;

	@Resource
	private LocaleResolver localeResolver;
	
	@Resource
	private FlightService flightService;
	
	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd HH:mm" );
	SimpleDateFormat mSimpleDateFormat2 = new SimpleDateFormat ( "yyyy-MM-dd" );
	SimpleDateFormat format3 = new SimpleDateFormat("yyyyMMdd");
	
    @RequestMapping(value="/intro/")
    public String intro(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	HashMap map = new HashMap();
    	map.put("language", localeResolver.resolveLocale(request));

    	List<HashMap> lstMainImage = mainService.getMainImageList();
    	List<HashMap> expsrList1 = goodsService.getGoodsExpsrList1(map);
    	List<HashMap> expsrList2 = goodsService.getGoodsExpsrList2(map);
    	List<HashMap> expsrList3 = goodsService.getGoodsExpsrList3(map);
    	List<HashMap> lstVideo = liveViewService.mainVideolist(map);
    	//List<HashMap> lstBanner = mainService.getBanner(null);
    	
    	List<HashMap> lstNotice = noticeService.mainNoticelist(map);
    	List<HashMap> popupNotice = noticeService.mainPopupNotice(map);
    	
        //model.addAttribute("expsrList1", expsrList1);
        //model.addAttribute("expsrList2", expsrList2);
    	
    	//접속이력
    	HttpSession session = request.getSession();
		String esntl_id = UserUtils.nvl((String)session.getAttribute("esntl_id"));
    	HashMap map2 = new HashMap();
    	map2.put("esntl_id", esntl_id);
    	map2.put("conect_ip", UserUtils.getUserIp(request));
    	loginService.connectLog(map2);
    	
        model.addAttribute("main_yn", "Y");
    	
        model.addAttribute("lstMainImage", lstMainImage);        
        model.addAttribute("hotdeal", expsrList1);
        model.addAttribute("reco", expsrList2);
        model.addAttribute("self", expsrList3);
        model.addAttribute("video", lstVideo);
        //model.addAttribute("lstBanner", lstBanner);        
        model.addAttribute("lstNotice", lstNotice);
        model.addAttribute("popupNotice", popupNotice);        
        
        model.addAttribute("bp", "07");
        model.addAttribute("btitle", "고객지원");
        model.addAttribute("mtitle", "여행후기");
        
        return "gnrl/main/intro";
    }
 
    @RequestMapping(value="/indexAction/")
    public String frameReset(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "gnrl/main/index";
    }
    
    @RequestMapping(value="/getMySchedule2")
    public @ResponseBody ResponseVo getMySchedule2(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
	    	
	    	List<Map> lst = mainService.getMySchedule(map);

	    	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd"); 
	    	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd"); 

	    	LinkedHashMap<String, Object> mapDate = new LinkedHashMap<String, Object>();
	    	
	    	for(int i = 0; i < lst.size(); i++) {
	    		if(lst.get(i).get("TOUR_DE") == null) {
	    			Date dt1 = format.parse(String.valueOf(lst.get(i).get("CHKIN_DE")));			
	    			Date dt2 = format.parse(String.valueOf(lst.get(i).get("CHCKT_DE")));
	    			
	    			Calendar startDt = Calendar.getInstance();
	    			startDt.setTime(dt1);

	    			int days = (int)((long)(dt2.getTime() - dt1.getTime()) / ( 24 * 60 * 60 * 1000 ));
	    			
	    			String time = "";
	    			String text = String.valueOf(lst.get(i).get("GOODS_NM"));
	    			for(int j = 0; j < days + 1; j++) {
	    				String strDt = format.format(startDt.getTime());
		    			addMySchedule(mapDate, strDt, time, text);
		    			startDt.add(Calendar.DATE, 1);
	    			}
	    		} else {
	    			Date dt1 = format.parse(String.valueOf(lst.get(i).get("TOUR_DE")));
	    			String strDt = format.format(dt1);	    			
	    			String BEGIN_TIME = String.valueOf(lst.get(i).get("BEGIN_TIME"));
	    			String END_TIME = String.valueOf(lst.get(i).get("END_TIME"));
	    			String time = BEGIN_TIME.substring(0, 2) + ":" + BEGIN_TIME.substring(2, 4) + " ~ " + END_TIME.substring(0, 2) + ":" + END_TIME.substring(2, 4);
	    			String text = String.valueOf(lst.get(i).get("GOODS_NM"));
	    			addMySchedule(mapDate, strDt, time, text);
	    		}
	    	}	
	    	
	    	List<Map> lstResult = new ArrayList();
	    	String[] weekNm = new String[] { "일", "월", "화", "수", "목", "금", "토" };
	    	
	    	for (Map.Entry<String,Object> entry : mapDate.entrySet()) {
	    		String strDt = entry.getKey();
	    		Date dt1 = format.parse(strDt);
	    		Calendar cal = Calendar.getInstance();
	    		cal.setTime(dt1);
	    		int dayNum = cal.get(Calendar.DAY_OF_WEEK);
	    		
	    		strDt = format2.format(dt1) + "(" + weekNm[dayNum - 1] + ")";
	    		List lstItem = (List)entry.getValue();
	    		Map<String, Object> m = new HashMap<String, Object>();
	    		m.put("day", strDt);
	    		m.put("list", lstItem);
	    		lstResult.add(m);
	    	}
	    	
	    	resVo.setData(lstResult);

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	    
	}
    
    private void addMySchedule(LinkedHashMap<String, Object> mapDate, String dt, String time, String text) {
    	if(!mapDate.containsKey(dt))
    		mapDate.put(dt, new ArrayList());
    	List lst = (List)mapDate.get(dt);
    	LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
    	map.put("time", time);
    	map.put("text", text);
    	lst.add(map);
    }

    @RequestMapping(value="/getMySchedule")
    public @ResponseBody ResponseVo getMySchedule(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
	    	
	    	// 비행기 정보 알아내기
	    	List<Map<String, String>> lstFlight = flightService.selectCurrentFlight(map);
	    	List<Map> lstSchedule = mainService.getMySchedule(map);
			int totalPrice = 0;
	    	Map<String, Object> mapResult = new HashMap<String, Object>();
	    	for(int i = 0; i < lstSchedule.size(); i++) {
	    		totalPrice += Integer.valueOf(String.valueOf(lstSchedule.get(i).get("PURCHS_AMOUNT")));
	    	}
	    	
	    	if(lstFlight.size() == 0) {
		    	// 비행기 정보가 없으면 일반으로.
	    		List<Map> lstResult = makeSchedule(lstSchedule);
    	    	mapResult.put("lst", lstResult);
    	    	mapResult.put("totalPrice", totalPrice);
	        	resVo.setData(mapResult);
	    	} else {
		    	// 비행기 출,도착 정보가 있을경우
	    		if(lstFlight.get(0).get("DTRMC_START_DT") == null || lstFlight.get(0).get("DTRMC_ARVL_DT") == null
	    				|| lstFlight.get(0).get("HMCMG_START_DT") == null || lstFlight.get(0).get("HMCMG_ARVL_DT") == null ) {
		    		List<Map> lstResult = makeSchedule(lstSchedule);
	    	    	mapResult.put("lst", lstResult);
	    	    	mapResult.put("totalPrice", totalPrice);
		        	resVo.setData(mapResult);
	    		} else {
			    	// 출발일 ~ 도착일 날짜 지정
	    			Date dtrmcStartDt = mSimpleDateFormat2.parse(lstFlight.get(0).get("DTRMC_START_DT").substring(0, 10));
	    			Date hmcmgStartDt = mSimpleDateFormat2.parse(lstFlight.get(0).get("HMCMG_START_DT").substring(0, 10));
	    			
	    			List<ScheduleDateVo> lstDate = new ArrayList();
	    			Calendar cStart = Calendar.getInstance();
	    			cStart.setTime(dtrmcStartDt);
	    			Calendar cEnd = Calendar.getInstance();
	    			cEnd.setTime(hmcmgStartDt);
	    			
	    			while(true) {
	    				ScheduleDateVo vo = new ScheduleDateVo();
	    				vo.setDate(mSimpleDateFormat2.format(cStart.getTime()));
	    				lstDate.add(vo);

	    				if(cStart.equals(cEnd))
	    					break;

	    				cStart.add(Calendar.DATE, 1);
	    			}
	    			
	    			ScheduleTimeVo t1 = new ScheduleTimeVo(lstFlight.get(0).get("DTRMC_START_DT"), lstFlight.get(0).get("DTRMC_START_ARPRT_NM") + " 공항 출발", "");
	    			ScheduleTimeVo t2 = new ScheduleTimeVo(lstFlight.get(0).get("DTRMC_ARVL_DT"), lstFlight.get(0).get("DTRMC_ARVL_ARPRT_NM") + " 공항 도착", "start");
	    			ScheduleTimeVo t3 = new ScheduleTimeVo(lstFlight.get(0).get("HMCMG_START_DT"), lstFlight.get(0).get("HMCMG_START_ARPRT_NM") + " 공항 출발", "end");
	    			ScheduleTimeVo t4 = new ScheduleTimeVo(lstFlight.get(0).get("HMCMG_ARVL_DT"), lstFlight.get(0).get("HMCMG_ARVL_ARPRT_NM") + " 공항 도착", "");
	    			
	    			ScheduleDateVo.addTime(lstDate, t1);
	    			ScheduleDateVo.addTime(lstDate, t2);
	    			ScheduleDateVo.addTime(lstDate, t3);
	    			ScheduleDateVo.addTime(lstDate, t4);
	    					
	    			// 날짜별 요소 지정
	    			ScheduleDateVo.setTable(lstDate);
	    			
	    			// 요소에 대입
	    	    	for(int i = 0; i < lstSchedule.size(); i++) {
	    	    		if(lstSchedule.get(i).get("TOUR_DE") == null) {
	    	    			/*
	    	    			Date dt1 = format.parse(String.valueOf(lst.get(i).get("CHKIN_DE")));			
	    	    			Date dt2 = format.parse(String.valueOf(lst.get(i).get("CHCKT_DE")));
	    	    			
	    	    			Calendar startDt = Calendar.getInstance();
	    	    			startDt.setTime(dt1);

	    	    			int days = (int)((long)(dt2.getTime() - dt1.getTime()) / ( 24 * 60 * 60 * 1000 ));
	    	    			
	    	    			String time = "";
	    	    			String text = String.valueOf(lst.get(i).get("GOODS_NM"));
	    	    			for(int j = 0; j < days + 1; j++) {
	    	    				String strDt = format.format(startDt.getTime());
	    		    			addMySchedule(mapDate, strDt, time, text);
	    		    			startDt.add(Calendar.DATE, 1);
	    	    			}
	    	    			*/
	    	    		} else {
	    	    			Date dt1 = format3.parse(String.valueOf(lstSchedule.get(i).get("TOUR_DE")));
	    	    			String strDt = mSimpleDateFormat2.format(dt1);	    			
	    	    			String BEGIN_TIME = String.valueOf(lstSchedule.get(i).get("BEGIN_TIME"));
	    	    			String END_TIME = String.valueOf(lstSchedule.get(i).get("END_TIME"));
	    	    			BEGIN_TIME = BEGIN_TIME.substring(0, 2) + ":" + BEGIN_TIME.substring(2, 4);
	    	    			END_TIME = END_TIME.substring(0, 2) + ":" + END_TIME.substring(2, 4);
	    	    			String text = String.valueOf(lstSchedule.get(i).get("GOODS_NM"));
	    	    			
	    	    			ScheduleDateVo.addTime(lstDate, strDt, BEGIN_TIME, END_TIME, text);	    	    			
	    	    		}    
	    	    		
	    	    	}
	    	    	mapResult.put("lst", lstDate);
	    	    	mapResult.put("totalPrice", totalPrice);
		        	resVo.setData(mapResult);
	    		}
	    	}	    	

			resVo.setResult("0");			
		} catch(Exception e) {
			resVo.setResult("9");			
			resVo.setMessage(e.getMessage());	
			e.printStackTrace();
		}
		
		return resVo;    	    
	}
    
    private List<Map> makeSchedule(List<Map> lst) throws Exception {
    	SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd"); 
    	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd"); 

    	LinkedHashMap<String, Object> mapDate = new LinkedHashMap<String, Object>();
    	
    	for(int i = 0; i < lst.size(); i++) {
    		if(lst.get(i).get("TOUR_DE") == null) {
    			Date dt1 = format.parse(String.valueOf(lst.get(i).get("CHKIN_DE")));			
    			Date dt2 = format.parse(String.valueOf(lst.get(i).get("CHCKT_DE")));
    			
    			Calendar startDt = Calendar.getInstance();
    			startDt.setTime(dt1);

    			int days = (int)((long)(dt2.getTime() - dt1.getTime()) / ( 24 * 60 * 60 * 1000 ));
    			
    			String time = "";
    			String text = String.valueOf(lst.get(i).get("GOODS_NM"));
    			for(int j = 0; j < days + 1; j++) {
    				String strDt = format.format(startDt.getTime());
	    			addMySchedule(mapDate, strDt, time, text);
	    			startDt.add(Calendar.DATE, 1);
    			}
    		} else {
    			Date dt1 = format.parse(String.valueOf(lst.get(i).get("TOUR_DE")));
    			String strDt = format.format(dt1);	    			
    			String BEGIN_TIME = String.valueOf(lst.get(i).get("BEGIN_TIME"));
    			String END_TIME = String.valueOf(lst.get(i).get("END_TIME"));
    			String time = BEGIN_TIME.substring(0, 2) + ":" + BEGIN_TIME.substring(2, 4) + " ~ " + END_TIME.substring(0, 2) + ":" + END_TIME.substring(2, 4);
    			String text = String.valueOf(lst.get(i).get("GOODS_NM"));
    			addMySchedule(mapDate, strDt, time, text);
    		}
    	}	
    	
    	List<Map> lstResult = new ArrayList();
    	String[] weekNm = new String[] { "일", "월", "화", "수", "목", "금", "토" };
    	
    	for (Map.Entry<String,Object> entry : mapDate.entrySet()) {
    		String strDt = entry.getKey();
    		Date dt1 = format.parse(strDt);
    		Calendar cal = Calendar.getInstance();
    		cal.setTime(dt1);
    		int dayNum = cal.get(Calendar.DAY_OF_WEEK);
    		
    		strDt = format2.format(dt1) + "(" + weekNm[dayNum - 1] + ")";
    		List lstItem = (List)entry.getValue();
    		Map<String, Object> m = new HashMap<String, Object>();
    		m.put("date", strDt);
    		m.put("lstTime", lstItem);
    		lstResult.add(m);
    	}
    	
    	return lstResult;
    }
}
