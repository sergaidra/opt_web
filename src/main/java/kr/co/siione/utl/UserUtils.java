package kr.co.siione.utl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class UserUtils {

	public static String nvl(String str) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return "";
		}
		return str;
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
	
	public static void log(Map<String, String> param) throws Exception  {
		System.out.println("==================== log start ==============================");		
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			System.out.println(rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		System.out.println("==================== log end ================================");
	}
	
	public static void log(String prefix, Map<String, String> param) throws Exception  {
		System.out.println(prefix+" ==================== log start ==============================");
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			System.out.println(prefix+" "+ rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		System.out.println(prefix+" ==================== log end ================================");
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
