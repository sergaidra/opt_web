package kr.co.siione.mngr.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;


@Controller
public class FlightManageController {
    
	protected Log log = LogFactory.getLog(this.getClass());
	
	private static final String ssUserId = "admin";
	
    @Inject
    MappingJackson2JsonView jsonView;
    
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
}