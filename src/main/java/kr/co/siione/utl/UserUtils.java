package kr.co.siione.utl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.imageio.ImageIO;

import kr.co.siione.utl.egov.EgovProperties;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

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
			String fileName = file.getOriginalFilename();
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
				int scaledWidth = bi.getWidth();
				int scaledHeight = bi.getHeight();
				
				if(bi.getWidth() > 3000) {
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
				}
				
				ImageResizer.resize(storePath + saveFileNm, resizePath + resizeFileNm, scaledWidth, scaledHeight);
			}
			
			//param.put("REGIST_PATH", "상품");
			//param.put("FILE_SN", "1");
			if(sDirName.equals("MAIN")) {
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
