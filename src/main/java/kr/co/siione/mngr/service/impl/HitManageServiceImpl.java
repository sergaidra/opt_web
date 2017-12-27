package kr.co.siione.mngr.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.siione.mngr.dao.GoodsHitDAO;
import kr.co.siione.mngr.service.HitManageService;
import kr.co.siione.utl.UserJSONUtils;
import kr.co.siione.utl.UserUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("HitManageService")
public class HitManageServiceImpl implements HitManageService {

	private static final Logger LOG = LoggerFactory.getLogger(HitManageServiceImpl.class);
	
	@Resource(name = "GoodsHitDAO")
	private GoodsHitDAO goodsHitDAO;
	
	@Override
	public List<Map<String, String>> selectGoodsHitList(Map<String, String> param) throws Exception {
		return goodsHitDAO.selectGoodsHitList(param);
	}
	
	@Override
	public void insertGoodsHit(Map<String, String> param) throws Exception {
		goodsHitDAO.insertGoodsHit(param);
	}
		
}
