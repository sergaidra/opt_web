package kr.co.siione.utl;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserUtils {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(UserUtils.class);
	
	public static String nvl(String str) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return "";
		}
		return str;
	}
	
	public static String nvl(String str, String restr) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return restr;
		}
		return str;
	}
	
	public static String nvl(Object obj) {
		if (obj == null || obj.toString().length() == 0 || obj.toString().equals(" ") || obj.toString().equals("null")) {
			return "";
		}
		return obj.toString();
	}
	
	public static String rpad(String str, int len, String addStr) {
		String result = str;
		int templen = len - result.length();

		for (int i = 0; i < templen; i++) {
			result += addStr;
		}

		return result;
	}
	
	public static String getDate(String sFormat) {
		SimpleDateFormat formatter = new SimpleDateFormat(sFormat, new Locale("ko", "KOREA"));
		return formatter.format(new Date());
	}
	
	public static Map<String, Object> toMap(JSONObject object) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		@SuppressWarnings("unchecked")
		Iterator<String> keys = object.keys();
		while(keys.hasNext()){
			String key = keys.next();
			Object value = object.get(key);
			
			if(value instanceof JSONArray){
				//value = toList(value);
			}
			else if(value instanceof JSONObject){
				value = toMap((JSONObject)value);
			}
			map.put(key, value);
		}
		return map;
	}
	
	public static List<Object> toList(JSONArray array) throws Exception {
		List<Object> list = new ArrayList<Object>();
		for(int i = 0; i < array.size(); i++){
			Object value = array.get(i);
			if(value instanceof JSONArray){
				value = toList((JSONArray)value);
			}
			else if(value instanceof JSONObject){
				value = toMap((JSONObject)value);
			}
			list.add(value);
		}
		return list;
	}
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getOpenAPIData(StringBuilder sb) throws Exception {
        JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(sb.toString());
        
        Map<String, Object> mapRoot     = UserUtils.toMap(jsonObject);
        Map<String, Object> mapResponse = (Map<String, Object>)mapRoot.get("response");
        Map<String, Object> mapBody     = (Map<String, Object>)mapResponse.get("body");
        Map<String, Object> mapItems    = (Map<String, Object>)mapBody.get("items");
        JSONArray list = (JSONArray)mapItems.get("item");
        
        return UserUtils.toList(list);
	}
	
	public static void log(Map<String, String> param) throws Exception  {
		LOGGER.debug("==================== log start ==============================");		
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			LOGGER.debug(rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		LOGGER.debug("==================== log end ================================");
	}
	
	public static void log(String prefix, Map<String, String> param) throws Exception  {
		LOGGER.debug(prefix+" ==================== log start ==============================");
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			LOGGER.debug(prefix+" "+ rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		LOGGER.debug(prefix+" ==================== log end ================================");
	}
	
	public static void log(List<Map<String, String>> param) throws Exception  {
		for(Map<String,String> map : param) {
			log(map);
		}
	}
	
	public static void log(String prefix, List<Map<String, String>> param) throws Exception  {
		for(Map<String,String> map : param) {
			log(prefix, map);
		}
	}

}
