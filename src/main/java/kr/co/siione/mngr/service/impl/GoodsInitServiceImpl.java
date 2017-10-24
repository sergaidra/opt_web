package kr.co.siione.mngr.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.DtaInitDAO;
import kr.co.siione.mngr.service.GoodsInitService;
import kr.co.siione.utl.UserUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("GoodsInitService")
public class GoodsInitServiceImpl implements GoodsInitService {

	private static final Logger LOG = LoggerFactory.getLogger(GoodsInitServiceImpl.class);
	
	@Resource(name = "DtaInitDAO")
	private DtaInitDAO dtaInitDAO;
	
	@Override
	public List<Map<String, String>> selectDtaInitList(Map<String, String> param) throws Exception {
		return dtaInitDAO.selectDtaInitList(param);
	}
	
	
	@Override
	public int initGoodsDta(Map<String, String> param) throws Exception {
		
		String[] arrTableNmList = UserUtils.nvl(param.get("TABLE_NM_LIST")).split(",");
		int iRe = 0;
		
		for(String sTableNm : arrTableNmList) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("TABLE_NM", sTableNm);
			map.put("INIT_ID", UserUtils.nvl(param.get("INIT_ID")));
			if(sTableNm.equals("TB_MAIN_IMAGE")) {
				iRe += dtaInitDAO.initDtaForMainImage(map);
			} else if(sTableNm.equals("TB_TOUR_CL")) {
				iRe += dtaInitDAO.initDtaForTourCl(map);
			} else if(sTableNm.equals("TB_GOODS")) {
				iRe += dtaInitDAO.initDtaForGoods(map);
			} else if(sTableNm.equals("TB_GOODS_ENG")) {
				iRe += dtaInitDAO.initDtaForGoodsEng(map);
			} else if(sTableNm.equals("TB_GOODS_NMPR")) {
				iRe += dtaInitDAO.initDtaForGoodsNmpr(map);
			} else if(sTableNm.equals("TB_GOODS_SCHDUL")) {
				iRe += dtaInitDAO.initDtaForGoodsSchdul(map);
			} else if(sTableNm.equals("TB_GOODS_TIME")) {
				iRe += dtaInitDAO.initDtaForGoodsTime(map);
			}
			
			System.out.println("======== delete & init => "+sTableNm+"/"+iRe);
		}
		

		

				
		return iRe;
	}



}
