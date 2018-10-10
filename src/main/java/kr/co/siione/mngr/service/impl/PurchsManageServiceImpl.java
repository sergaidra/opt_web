package kr.co.siione.mngr.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.gnrl.cmmn.service.CommonService;
import kr.co.siione.gnrl.purchs.service.impl.OrderDAO;
import kr.co.siione.mngr.dao.PurchsDAO;
import kr.co.siione.mngr.service.PurchsManageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("PurchsManageService")
public class PurchsManageServiceImpl implements PurchsManageService {

	private static final Logger LOG = LoggerFactory.getLogger(PurchsManageServiceImpl.class);
	
	@Resource(name = "PurchsDAO")
	private PurchsDAO purchsDAO;
	@Resource
	private CommonService commonService;
	@Resource(name = "orderDAO")
	private OrderDAO orderDAO;

	public List<Map<String, Object>> selectPurchsList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsList(param);
	}
	
	public int selectPurchsListCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListCount(param);
	}
	
	public List<Map<String, Object>> selectPurchsGoodsList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsGoodsList(param);
	}
	
	public List<Map<String, String>> selectPurchsListForSchdul(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListForSchdul(param);
	}
	
	public int selectPurchsListForSchdulCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectPurchsListForSchdulCount(param);
	}
	
	public List<Map<String, String>> selectPayList(Map<String, String> param) throws Exception {
		return purchsDAO.selectPayList(param);
	}
	
	@Override
	public int refundPurchs(Map<String, String> param) throws Exception {
		int iRe = purchsDAO.refundPurchs(param);

		if(iRe == 0) {
			throw new Exception("환불처리 중 오류 발생!");
		}

		return iRe;
	}
	
	public List<Map<String, Object>> selectOrderWaitList(Map<String, String> param) throws Exception {
		return purchsDAO.selectOrderWaitList(param);
	}
	
	public int selectOrderWaitListCount(Map<String, String> param) throws Exception {
		return purchsDAO.selectOrderWaitListCount(param);
	}
	
	public int updateReservationStatus(Map<String, String> map) throws Exception {
		purchsDAO.updateReservationStatus(map);

		// 예약자 정보
		HashMap m = new HashMap();
		m.put("cart_sn", map.get("CART_SN"));
		
		HashMap info = orderDAO.getUserInfoByCart(m);
		m.put("esntl_id", info.get("ESNTL_ID"));
		HashMap mapCart = orderDAO.getCartDetail(m);

		// 메일 발송
		Map<String, Object> attachMap = new HashMap<String, Object>();
		attachMap.put("images", new ArrayList());

		String subject = "원패스투어 예약 확정드립니다.";
		String title = "예약 확정드립니다. 결재하시기 바랍니다.";
		String file_code = String.valueOf(mapCart.get("FILE_CODE"));
		String goods_nm = String.valueOf(mapCart.get("GOODS_NM"));
		String date = String.valueOf(mapCart.get("GOODS_DATE"));
		String options = String.valueOf(mapCart.get("GOODS_TIME"));		
		String item_amount = String.format("%,d", Integer.valueOf(String.valueOf(mapCart.get("ORIGIN_AMOUNT"))));

		if(!"".equals(options))
			options += "<br/>";
		options += String.valueOf(mapCart.get("GOODS_OPTION"));

    	List<HashMap> lstManager = commonService.getManagerUser(new HashMap());
    	for(int i = 0;i < lstManager.size(); i++)
    		commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount, String.valueOf(map.get("email")));
    	
    	commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount,"onepasstour@gmail.com");
    	commonService.mailWaitComfirm(subject, title, file_code, goods_nm, date, options, item_amount, String.valueOf(info.get("EMAIL")));
	 
		return 1;
	}
}
