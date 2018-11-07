package kr.co.siione.mngr.job;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.web.client.RestTemplate;

import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.mngr.service.ExchangeService;

public class ExchangeJob  extends QuartzJobBean {
	private ApplicationContext ctx;
	private ExchangeService exchangeService;

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {		
		ctx = (ApplicationContext)context.getJobDetail().getJobDataMap().get("applicationContext");		
		jobInit(context);
	}

	private void jobInit(JobExecutionContext context) {
		exchangeService = (ExchangeService) ctx.getBean("ExchangeService");

		// RestTemplate 에 MessageConverter 세팅
	    List<HttpMessageConverter<?>> converters = new ArrayList<HttpMessageConverter<?>>();
	    converters.add(new FormHttpMessageConverter());
	    converters.add(new StringHttpMessageConverter());
	 
	    RestTemplate restTemplate = new RestTemplate();
	    //restTemplate.setMessageConverters(converters);
	    
	    // parameter 세팅
	    Map<String, String> map = new HashMap<String, String>();
	    //map.add("str", "thisistest");
	    
		String result = restTemplate.getForObject("http://api.manana.kr/exchange/rate.json", String.class, map);
		System.out.println(result);

		JSONParser jsonParser = new JSONParser();
		
		//JSON데이터를 넣어 JSON Object 로 만들어 준다.
        try {
        	JSONArray jsonArray = (JSONArray) jsonParser.parse(result);
        	for(int i = 0; i < jsonArray.size(); i++) {
        		JSONObject o = (JSONObject)jsonArray.get(i);

        		//executeJob(orderService);

        		System.out.println(o.get("name") + " : "  + o.get("rate"));
        		
        		HashMap mapP = new HashMap();
        		mapP.put("NAME", o.get("name"));
        		mapP.put("RATE", o.get("rate"));

				exchangeService.insertExchange(mapP);
        	}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
