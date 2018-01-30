package kr.co.siione.utl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.siione.utl.egov.EgovProperties;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

public class UserUtils {

	private static final Logger LOG = LoggerFactory.getLogger(UserUtils.class);

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

	public static String nvl(Object obj, String str) {
		if (obj == null || obj.toString().length() == 0 || obj.toString().equals(" ")) {
			return str;
		}
		return obj.toString();
	}

	public static String nvl(Object obj) {
		if (obj == null || obj.toString().length() == 0 || obj.toString().equals(" ") || obj.toString().equals("null")) {
			return "";
		}
		return obj.toString();
	}

	public static String rpad(String str, int len, String addStr) {
		if(str == null) str = "";
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

	/**
	 * 특정 날짜에 대하여 요일을 구함(일 ~ 토)
	 * @param date
	 * @param dateType
	 * @return
	 * @throws Exception
	 */
	public static String getDateDay(String date, String dateType) throws Exception {
		String day = "";

		SimpleDateFormat dateFormat = new SimpleDateFormat(dateType);
		Date nDate = dateFormat.parse(date);

		Calendar cal = Calendar.getInstance();
		cal.setTime(nDate);

		int dayNum = cal.get(Calendar.DAY_OF_WEEK);

		switch (dayNum) {
		case 1:
			day = "일";
			break;
		case 2:
			day = "월";
			break;
		case 3:
			day = "화";
			break;
		case 4:
			day = "수";
			break;
		case 5:
			day = "목";
			break;
		case 6:
			day = "금";
			break;
		case 7:
			day = "토";
			break;

		}

		return day;
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

	@SuppressWarnings("rawtypes")
	public static Map<String,String> getRequestParameter(HttpServletRequest request) {
		Map<String,String> map = new HashMap<String,String>();
		Enumeration e = request.getParameterNames();

		while (e.hasMoreElements()) {
			String a = (String) e.nextElement();
			map.put(a, StringUtils.replace(nvl(request.getParameter(a).trim()), "&quot;", "\""));
		}

		return map;
	}

	/**
	 * 파일명 한글처리
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getUserBrower(request);
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if(browser.equals("MSIE")){
			encodedFilename =  URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		}else if(browser.equals("FireFox")){
			encodedFilename = "\""+ new String(filename.getBytes("UTF-8"),"8859_1"+"\"");
		}else if(browser.equals("Opera")){
			encodedFilename = "\""+ new String(filename.getBytes("UTF-8"),"8859_1"+"\"");
		}else if(browser.equals("Chrome")){
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < filename.length(); i++){
				char c = filename.charAt(i);
				if(c > '~'){
					sb.append(URLEncoder.encode(""+c,"UTF-8"));
				}else{
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		}else{
			throw new IOException("Not surported browser");
		}
		response.setHeader("Content-Disposition", dispositionPrefix+encodedFilename);

		if("Opera".equals(browser)){
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}


	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getOpenAPIData(StringBuilder sb) throws Exception {
		JSONObject jsonObject = (JSONObject) JSONSerializer.toJSON(sb.toString());

		Map<String, Object> mapRoot     = UserUtils.toMap(jsonObject);
		Map<String, Object> mapResponse = (Map<String, Object>)mapRoot.get("response");
		Map<String, Object> mapBody     = (Map<String, Object>)mapResponse.get("body");

		int cnt = 0;

		if(mapBody.containsKey("totalCount")) {
			cnt = Integer.parseInt(UserUtils.nvl(mapBody.get("totalCount")));
		} else {
			cnt = 99999;
		}

		JSONArray list = null;
		if(cnt > 0) {
			Map<String, Object> mapItems = (Map<String, Object>)mapBody.get("items");
			list = (JSONArray)mapItems.get("item");
			return UserUtils.toList(list);
		} else {
			return null;
		}
	}

	/**
	 *
	 * <pre>
	 * 1. 메소드명 : getFileInfo
	 * 2. 설명 :
	 * 3. 작성일 : 2017. 10. 20.
	 * </pre>
	 * @param file
	 * @param sDirName : 중간폴더 명
	 * @param isThumb : 썸네일 이미지 저장 여부
	 * @return
	 * @throws Exception
	 */
	public static HashMap<String, String> getFileInfo(MultipartFile file, String sDirName, boolean isThumb) throws Exception {
		FileOutputStream fos = null;
		HashMap<String, String> fileParam = new HashMap<String, String>();

		String sFileStorePath = EgovProperties.getProperty("Globals.fileStorePath");
		String sFileSeparator = File.separator;
		String sPreFix = UserUtils.getDate("yyyyMMddHHmmss");
		
		try {
			//핫딜이미지 (파일2개 이름이 같으면 덮어버림)
			String sDiv = sDirName;
			if(sDirName.startsWith("HOTDEAL")) {
				sDirName = "HOTDEAL";
				sDiv = StringUtils.replace(sDiv, "HOTDEAL_", "") + "_";
			} else {
				sDiv = "";
			}
			
			String fileName = sDiv + file.getOriginalFilename();
			String saveFileNm = sPreFix + "_" + fileName;

			String storePath  = sFileStorePath + sDirName + sFileSeparator;
			File f = new File(storePath);
			if (!f.exists()) f.mkdirs();

			fos = new FileOutputStream(storePath + saveFileNm);
			fos.write(file.getBytes());

			// 상품 썸네일 이미지 저장
			if(isThumb) {
				String resizeFileNm = sPreFix + "_" + fileName.substring(0, fileName.lastIndexOf(".")) + "_resize" + fileName.substring(fileName.lastIndexOf("."));
				String resizePath = sFileStorePath + sDirName + sFileSeparator + "thumb" + sFileSeparator;
				File f2 = new File(resizePath);
				if (!f2.exists()) f2.mkdirs();

				BufferedImage bi = ImageIO.read(new File(storePath + saveFileNm));

				int scaledWidth = 200; //bi.getWidth();    //x
				int scaledHeight = 148;
				
				if(sDirName.equals("MAIN")) {
					scaledWidth = 280;
					scaledHeight = 112;
				}
				//int scaledHeight = Math.round((bi.getHeight()*200)/bi.getWidth());; //bi.getHeight();  //y    z=(y*200)/x

				/*if(bi.getWidth() > 3000) {
					scaledWidth = bi.getWidth()/15;
					scaledHeight = bi.getHeight()/15;
				} else if(bi.getWidth() > 2500) {
					scaledWidth = bi.getWidth()/12;
					scaledHeight = bi.getHeight()/12;
				} else if(bi.getWidth() > 2000) {
					scaledWidth = bi.getWidth()/10;
					scaledHeight = bi.getHeight()/10;
				} else if(bi.getWidth() > 1500) {
					scaledWidth = bi.getWidth()/7;
					scaledHeight = bi.getHeight()/7;
				} else if(bi.getWidth() > 1000) {
					scaledWidth = bi.getWidth()/5;
					scaledHeight = bi.getHeight()/5;
				}*/

				ImageResizer.resize(storePath + saveFileNm, resizePath + resizeFileNm, scaledWidth, scaledHeight);
			}

			//param.put("REGIST_PATH", "상품");
			//param.put("FILE_SN", "1");
			if(sDirName.equals("MAIN") || sDirName.equals("BANNER")) {
				fileParam.put("IMAGE_NM", fileName);
				fileParam.put("IMAGE_PATH", storePath + saveFileNm);
				fileParam.put("IMAGE_SIZE", String.valueOf(file.getSize()));
			} else {
				fileParam.put("FILE_NM", fileName);
				fileParam.put("FILE_PATH", storePath + saveFileNm);
				fileParam.put("FILE_SIZE", String.valueOf(file.getSize()));
				fileParam.put("FILE_CL", ((file.getContentType().indexOf("image") > -1)?"I":"M")); // I:이미지, M:동영상
			}

		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(fos != null) fos.close();
		}
		return fileParam;
	}

	public static String getUserIp(HttpServletRequest request) {
		String ip = null;
		ip = request.getHeader("X-Forwarded-For");
		/*if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP"); //웹로직
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("X-Real-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("X-RealIP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("REMOTE_ADDR");
		}*/
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	public static String getUserBrower(HttpServletRequest request){
		String agent = request.getHeader("User-Agent");
		String brower = null;

		if (agent != null) {
			if(agent.indexOf("MSIE") > -1){
				brower = "MSIE";
			} else if(agent.indexOf("Trident") > -1) {
				brower = "MSIE";
			} else if(agent.indexOf("Chrome") > -1) {
				brower = "Chrome";
			} else if(agent.indexOf("Firefox") > -1) {
				brower = "Firefox";
			} else if(agent.indexOf("Opera") > -1) {
				brower = "Opera";
			} else if(agent.indexOf("iPhone") > -1 && agent.indexOf("Mobile") > -1) {
				brower = "iPhone";
			} else if(agent.indexOf("Android") > -1 && agent.indexOf("Mobile") > -1) {
				brower = "Android";
			} else {
				brower = "Opera";
			}
		}
		return brower;
	}

	public static String getUserOs(HttpServletRequest request){
		String agent = request.getHeader("User-Agent");
		String os = null;

		if(agent.indexOf("NT 6.0") != -1) os = "Windows Vista/Server 2008";
		else if(agent.indexOf("NT 5.2") != -1) os = "Windows Server 2003";
		else if(agent.indexOf("NT 5.1") != -1) os = "Windows XP";
		else if(agent.indexOf("NT 5.0") != -1) os = "Windows 2000";
		else if(agent.indexOf("NT") != -1) os = "Windows NT";
		else if(agent.indexOf("9x 4.90") != -1) os = "Windows Me";
		else if(agent.indexOf("98") != -1) os = "Windows 98";
		else if(agent.indexOf("95") != -1) os = "Windows 95";
		else if(agent.indexOf("Win16") != -1) os = "Windows 3.x";
		else if(agent.indexOf("Windows") != -1) os = "Windows";
		else if(agent.indexOf("Linux") != -1) os = "Linux";
		else if(agent.indexOf("Macintosh") != -1) os = "Macintosh";
		else os = "";

		return os;
	}

	public static String convertDate(String str) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return "";
		}
		if (str.length() == 8) {
			return str.substring(0, 4) + "-" + str.substring(4, 6) + "-" + str.substring(6, 8);
		} else {
			return "";
		}
	}

	public static String convertTime(String str) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return "";
		}
		if (str.length() == 4) {
			return str.substring(0, 2) + ":" + str.substring(2, 4);
		} else {
			return "";
		}
	}


	public static void log(Map<String, String> param) throws Exception  {
		LOG.debug("==================== log start ==============================");
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			LOG.debug(rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		LOG.debug("==================== log end ================================");
	}

	public static void log(String prefix, Map<String, String> param) throws Exception  {
		LOG.debug(prefix+" ==================== log start ==============================");
		Iterator<Map.Entry<String, String>> it = param.entrySet().iterator();
		while(it.hasNext()) {
			Map.Entry<String, String> entry = it.next();
			LOG.debug(prefix+" "+ rpad(entry.getKey(), 20, " ") + ": " + String.valueOf(entry.getValue()));
		}
		LOG.debug(prefix+" ==================== log end ================================");
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
