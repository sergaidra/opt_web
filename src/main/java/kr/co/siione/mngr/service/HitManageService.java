package kr.co.siione.mngr.service;

import java.util.List;
import java.util.Map;

public interface HitManageService {

	public List<Map<String, String>> selectGoodsHitList(Map<String, String> param) throws Exception;

	public void insertGoodsHit(Map<String, String> param) throws Exception;
}

