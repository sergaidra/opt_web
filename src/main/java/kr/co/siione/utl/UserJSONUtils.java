package kr.co.siione.utl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

public class UserJSONUtils {

	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : convertMap2Json
	 * 2. 설명 : json을 Map형으로 변환
	 * 3. 작성일 : 2017. 5. 16.
	 * </pre>
	 * @param map JSONObject으로 변환하는 Map<String, String>
	 * @return
	 */
	public JSONObject convertMap2Json(Map<String,String> map) {
		return JSONObject.fromObject(JSONSerializer.toJSON(map));
	}
	
	/**
	 * 
	 * <pre>
	 * 1. 메소드명 : convertJson2Map
	 * 2. 설명 : json을 Map형으로 변환
	 * 3. 작성일 : 2017. 5. 16.
	 * </pre>
	 * @param json Map<String,String> json의 Map형태
	 * @return
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public Map<String,String> convertJson2Map(JSONObject json) throws JsonParseException, JsonMappingException, IOException {
		return (new ObjectMapper()).readValue(json.toString(), HashMap.class);
	}	
}
