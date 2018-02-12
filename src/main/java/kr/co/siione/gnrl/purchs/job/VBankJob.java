package kr.co.siione.gnrl.purchs.job;

import java.util.HashMap;
import java.util.List;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import kr.co.siione.gnrl.purchs.service.OrderService;
import kr.co.siione.utl.UserUtils;

public class VBankJob  extends QuartzJobBean {
	private ApplicationContext ctx;
	private OrderService orderService;

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {		
		ctx = (ApplicationContext)context.getJobDetail().getJobDataMap().get("applicationContext");		
		jobInit(context);
	}

	private void jobInit(JobExecutionContext context) {
		orderService = (OrderService) ctx.getBean("OrderService");
		//executeJob(orderService);
		HashMap map = new HashMap();
		
		try {
			List<HashMap> lst = orderService.getPastVBank(map);
			System.out.println("getPastVBank:"+lst);

			for(int i = 0; i < lst.size(); i++) {
				String purchs_sn = String.valueOf(lst.get(i).get("PURCHS_SN"));
				String esntl_id = String.valueOf(lst.get(i).get("ESNTL_ID"));				
				String delete_resn_se = "003";
				String delete_resn_etc = "";

		    	map.put("purchs_sn", purchs_sn);   
		    	map.put("delete_resn_se", delete_resn_se);
		    	map.put("delete_resn_etc", delete_resn_etc);
		    	map.put("esntl_id", esntl_id);
		    	System.out.println("[cancelPurchs]map:"+map);
		    	
		    	HashMap mapAmount = orderService.getCancelRefundAmount(map);
		    	map.put("refund_amount", String.valueOf(mapAmount.get("REAL_SETLE_AMOUNT")));
		    	map.put("real_setle_amount", String.valueOf(mapAmount.get("REAL_SETLE_AMOUNT")));
		    	
		    	map.put("VBankPast", "Y");
		    	orderService.cancelPurchs(map);
			}
		} catch(Exception ex) {
			
		}
	}

}
