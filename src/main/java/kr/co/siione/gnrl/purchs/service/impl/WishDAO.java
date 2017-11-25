package kr.co.siione.gnrl.purchs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class WishDAO extends EgovComAbstractDAO {
	public int getWishListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.wish.selectWishListCount", map);
	}

	public List<HashMap> getWishList(HashMap map) throws Exception {
		return list("gnrl.wish.selectWishList", map);
	}

}
