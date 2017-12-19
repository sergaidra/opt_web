package kr.co.siione.mngr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository("BannerDAO")
public class BannerDAO extends EgovComAbstractDAO {

	public Object insertBanner(Map<String, String> map) throws Exception {
		return insert("BannerDAO.insertBanner", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectBannerList(Map<String, String> param) throws Exception {
		return list("BannerDAO.selectBannerList", param);
	}
	
	public int updateBanner(Map<String, String> map) throws Exception {
		return update("BannerDAO.updateBanner", map);
	}
}
