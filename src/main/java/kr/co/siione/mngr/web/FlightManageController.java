package kr.co.siione.mngr.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;


@Controller
public class FlightManageController {

	protected Log log = LogFactory.getLog(this.getClass());

	@Inject
	MappingJackson2JsonView jsonView;

	// 인천국제공항 실시간 정보 (필요없음)
	@RequestMapping(value="/flight/FlightInfo/")
	public String FlightInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {

		System.out.println("############################### FlightInfo ##########################################################");
		
		System.out.println("param:"+param);
		
		if(param == null) System.out.println("(1) null");
		if(param.size() == 0) System.out.println("(2) size 0");
		
		List list = null;
		String sUrl = "http://openapi.airport.kr/openapi/service/StatusOfPassengerFlights/getPassengerDepartures";
		String sKey = "LV8R80VFQsXbB6kh4u1EU9PMC0YC6ZoKhwy9NsD2OIIUMFExnRJLQlz%2BoswdXUm5Xapk7kBLllNnAYTN6gchKw%3D%3D"; 
		
		try {
			if(param.size() > 0) {
				StringBuilder urlBuilder = new StringBuilder(sUrl); /*URL*/
				urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + sKey); /*Service Key*/
				urlBuilder.append("&" + URLEncoder.encode("from_time" , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("from_time"), "0000"), "UTF-8")); /*검색 시작 시간 (HHMM)*/
				urlBuilder.append("&" + URLEncoder.encode("to_time"   , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("to_time"), "2400"), "UTF-8")); /*검색 종료 시간 (HHMM)*/
				urlBuilder.append("&" + URLEncoder.encode("airport"   , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("airport")), "UTF-8")); /*도착지 공항 코드*/
				urlBuilder.append("&" + URLEncoder.encode("flight_id" , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("flight_id")), "UTF-8")); /*운항 편명*/
				urlBuilder.append("&" + URLEncoder.encode("airline"   , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("airline")), "UTF-8")); /*항공사 코드*/
				urlBuilder.append("&" + URLEncoder.encode("lang"      , "UTF-8") + "=" + URLEncoder.encode("K", "UTF-8")); /*국문=K, 영문=E, 중문=C, 일문=J, Null=K*/
				urlBuilder.append("&" + URLEncoder.encode("_type"     , "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
				URL url = new URL(urlBuilder.toString());
				System.out.println("URL:"+urlBuilder.toString());
				
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Content-type", "application/json");
				System.out.println("Response code: " + conn.getResponseCode());
				BufferedReader rd;
				if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
					rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				} else {
					rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
				}
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = rd.readLine()) != null) {
					sb.append(line);
				}
				rd.close();
				conn.disconnect();
		   
				list = UserUtils.getOpenAPIData(sb);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}

		model.put("flightApiData", list);
		
		return "/flight/FlightInfo";
	} 	
	
	// 한국공항공사 국제선 여객기 정보
	@RequestMapping(value="/flight/KoreaFlightInfo/")
	public String KoreaFlightInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {

		System.out.println("############################### FlightInfo ##########################################################");
		
		System.out.println("param:"+param);
		
		if(param == null) System.out.println("(1) null");
		if(param.size() == 0) System.out.println("(2) size 0");
		
		List list = null;
		String sUrl = "http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList";
		String sKey = "LV8R80VFQsXbB6kh4u1EU9PMC0YC6ZoKhwy9NsD2OIIUMFExnRJLQlz%2BoswdXUm5Xapk7kBLllNnAYTN6gchKw%3D%3D"; 
		
		try {
			if(param.size() > 0) {
				StringBuilder urlBuilder = new StringBuilder(sUrl); /*URL*/
				urlBuilder.append("?" + URLEncoder.encode("ServiceKey"     , "UTF-8") + "=" + sKey); /*Service Key*/
				urlBuilder.append("&" + URLEncoder.encode("schDate"        , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schDate").replace("-", ""), "20170924"), "UTF-8")); /*검색일자*/
				urlBuilder.append("&" + URLEncoder.encode("schDeptCityCode", "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schDeptCityCode"), ""), "UTF-8")); /*출발 도시 코드*/
				urlBuilder.append("&" + URLEncoder.encode("schArrvCityCode", "UTF-8") + "=" + UserUtils.nvl(param.get("schArrvCityCode"))); //URLEncoder.encode(UserUtils.nvl(param.get("schArrvCityCode")), "CEB")); /*도착 도시 코드*/
				urlBuilder.append("&" + URLEncoder.encode("schAirLine"     , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schAirLine")), "UTF-8")); /*항공편 코드*/
				urlBuilder.append("&" + URLEncoder.encode("schFlightNum"   , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schFlightNum")), "UTF-8")); /*항공편 넘버*/
				urlBuilder.append("&" + URLEncoder.encode("_type"          , "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
				urlBuilder.append("&" + URLEncoder.encode("numOfRows"      , "UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8"));
				URL url = new URL(urlBuilder.toString());
				System.out.println("URL:"+urlBuilder.toString());
				
				//String str = "http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList?serviceKey=LV8R80VFQsXbB6kh4u1EU9PMC0YC6ZoKhwy9NsD2OIIUMFExnRJLQlz%2BoswdXUm5Xapk7kBLllNnAYTN6gchKw%3D%3D&schDate=20170924&schArrvCityCode=CEB&_type=json";
				//url = new URL(str);
				
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Content-type", "application/json");
				System.out.println("Response code: " + conn.getResponseCode());
				BufferedReader rd;
				if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
					rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				} else {
					rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
				}
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = rd.readLine()) != null) {
					sb.append(line);
				}
				rd.close();
				conn.disconnect();
		   
				list = UserUtils.getOpenAPIData(sb);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}

		if(list == null) {
			model.put("msg", "자료가 없습니다.");	
		}
		
		model.put("flightApiData", list);
		
		return "/flight/KoreaFlightInfo";
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/flight/getKoreaFlightInfo/")
	public @ResponseBody ResponseEntity<String> getKoreaFlightInfo(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param) throws Exception {
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
 			List list = null;
 			List reList = new ArrayList();
 			
			String sUrl = "http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList";
			String sKey = "LV8R80VFQsXbB6kh4u1EU9PMC0YC6ZoKhwy9NsD2OIIUMFExnRJLQlz%2BoswdXUm5Xapk7kBLllNnAYTN6gchKw%3D%3D"; 
			
			UserUtils.log("[한국공항 항공스케줄]param", param);
			
			try {
				if(param.size() > 0) {
					
					StringBuilder urlBuilder = new StringBuilder(sUrl); /*URL*/
					urlBuilder.append("?" + URLEncoder.encode("ServiceKey"     , "UTF-8") + "=" + sKey); /*Service Key*/
					urlBuilder.append("&" + URLEncoder.encode("schDate"        , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schDate").replace("-", "")), "UTF-8")); /*검색일자*/
					urlBuilder.append("&" + URLEncoder.encode("schDeptCityCode", "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schDeptCityCode")), "UTF-8")); /*출발 도시 코드*/
					urlBuilder.append("&" + URLEncoder.encode("schArrvCityCode", "UTF-8") + "=" + UserUtils.nvl(param.get("schArrvCityCode"))); //URLEncoder.encode(UserUtils.nvl(param.get("schArrvCityCode")), "CEB")); /*도착 도시 코드*/
					urlBuilder.append("&" + URLEncoder.encode("schAirLine"     , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schAirLine")), "UTF-8")); /*항공편 코드*/
					urlBuilder.append("&" + URLEncoder.encode("schFlightNum"   , "UTF-8") + "=" + URLEncoder.encode(UserUtils.nvl(param.get("schFlightNum")), "UTF-8")); /*항공편 넘버*/
					urlBuilder.append("&" + URLEncoder.encode("_type"          , "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
					urlBuilder.append("&" + URLEncoder.encode("numOfRows"      , "UTF-8") + "=" + URLEncoder.encode("10000", "UTF-8"));
					URL url = new URL(urlBuilder.toString());
					System.out.println("URL:"+urlBuilder.toString());
					
					//String str = "http://openapi.airport.co.kr/service/rest/FlightScheduleList/getIflightScheduleList?serviceKey=LV8R80VFQsXbB6kh4u1EU9PMC0YC6ZoKhwy9NsD2OIIUMFExnRJLQlz%2BoswdXUm5Xapk7kBLllNnAYTN6gchKw%3D%3D&schDate=20170924&schArrvCityCode=CEB&_type=json";
					//url = new URL(str);
					
					HttpURLConnection conn = (HttpURLConnection) url.openConnection();
					conn.setRequestMethod("GET");
					conn.setRequestProperty("Content-type", "application/json");
					System.out.println("Response code: " + conn.getResponseCode());
					BufferedReader rd;
					if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
						rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
					} else {
						rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
					}
					StringBuilder sb = new StringBuilder();
					String line;
					while ((line = rd.readLine()) != null) {
						sb.append(line);
					}
					rd.close();
					conn.disconnect();
			   
					list = UserUtils.getOpenAPIData(sb);

					String day = UserUtils.getDateDay(UserUtils.nvl(param.get("schDate")), "yyyy-MM-dd");
					System.out.println("day:"+day);
					
					for(int i = 0 ; i < list.size() ; i++) {
						HashMap<String, Object> map = (HashMap<String, Object>)list.get(i);
						System.out.println("==>"+map);
						if(map.get("internationalIoType").toString().equals(UserUtils.nvl(param.get("schType")))) {
							if(day.equals("월") && map.get("internationalMon").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("화") && map.get("internationalTue").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("수") && map.get("internationalWed").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("목") && map.get("internationalThu").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("금") && map.get("internationalFri").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("토") && map.get("internationalSat").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} else if(day.equals("일") && map.get("internationalSun").toString().equals("Y")) {
								reList.add(setFlightInfo(map));
								System.out.println("==>"+day+" 추가");
							} 
						}
					}
					
					System.out.println("list:"+list);
					System.out.println("reList:"+reList);
					
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			obj.put("arlineSchdulList", reList);
			retValue = "0";
		}

		obj.put("result", retValue);
		
		
		System.out.println("flight_obj::"+obj);
		
		entity = new ResponseEntity<String>(obj.toString(), responseHeaders, HttpStatus.CREATED);

		return entity;
	}
	
	@RequestMapping(value="/flight/flightSchedule/")
	public String goodsManage(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		try {
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/flight/flightSchedule";
	}
	
	public static HashMap<String, Object> setFlightInfo(HashMap<String, Object> map) {
		HashMap<String, Object> info = new HashMap<String, Object>();
		if(map.get("internationalIoType").toString().equals("OUT")) {
			info.put("STARTARVL_DIV", "S");	
		} else {
			info.put("STARTARVL_DIV", "D");
		}
		
		info.put("ARLINE_NM", map.get("airlineKorean"));
		info.put("ARLINE_NUM", map.get("internationalNum"));
		info.put("SCHDUL_TM", map.get("internationalTime"));
		
		info.put("CF_SCHDUL_TM", map.get("internationalTime").toString().substring(0,2)+":"+map.get("internationalTime").toString().substring(2));
		info.put("CF_TMPR_START_DE", "");
		info.put("CF_TMPR_START_TM", "");
		info.put("CF_TMPR_ARVL_DE", "");
		info.put("CF_TMPR_ARVL_TM", "");
		
		if(map.get("internationalIoType").toString().equals("OUT")) {
			info.put("CF_START_CTY", map.get("airport"));
			info.put("CF_ARVL_CTY", map.get("city"));	
		} else {
			info.put("CF_START_CTY", map.get("city"));
			info.put("CF_ARVL_CTY", map.get("airport"));
		}
		return info;
	}
}