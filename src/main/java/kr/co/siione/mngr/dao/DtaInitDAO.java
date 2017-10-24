package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("DtaInitDAO")
public class DtaInitDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectDtaInitList(Map<String, String> param) throws Exception {
		return list("DtaInitDAO.selectDtaInitList", param);
	}
	
	public int updateDtaInit(Map<String, String> param) throws Exception {
		return update("DtaInitDAO.updateDtaInit", param);
	}
	
	public int initDtaForMainImage(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForMainImage", param);
		return updateDtaInit(param);
	}
	
	public int initDtaForTourCl(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForTourCl", param);
		return updateDtaInit(param);
	}	
	
	public int initDtaForGoods(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForGoods", param);
		return updateDtaInit(param);
	}	
	
	public int initDtaForGoodsEng(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForGoodsEng", param);
		return updateDtaInit(param);
	}	

	public int initDtaForGoodsNmpr(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForGoodsNmpr", param);
		return updateDtaInit(param);
	}
	
	public int initDtaForGoodsSchdul(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForGoodsSchdul", param);
		return updateDtaInit(param);
	}
	
	public int initDtaForGoodsTime(Map<String, String> param) throws Exception {
		delete("DtaInitDAO.initDtaForGoodsTime", param);
		return updateDtaInit(param);
	}	
}
