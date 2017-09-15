package kr.co.siione.gnrl.goods.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class GoodsDAO extends EgovComAbstractDAO {

	public List selectGoodsExpsrList1() throws Exception {
		return list("gnrl.goods.selectGoodsExpsrList1");
	}
	
	public List selectGoodsExpsrList2() throws Exception {
		return list("gnrl.goods.selectGoodsExpsrList2");
	}	
	
	public List selectUpperTourClMain(HashMap map) throws Exception {
		return list("gnrl.goods.selectUpperTourClMain", map);
	}
	
	public List selectTourClList(HashMap map) throws Exception {
		return list("gnrl.goods.selectTourClList", map);
	}

    public HashMap selectTourClDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.goods.selectTourClDetail", map);
    }

	public List selectGoodsList(HashMap map) throws Exception {
		return list("gnrl.goods.selectGoodsList", map);
	}

    public HashMap selectGoodsDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.goods.selectGoodsDetail", map);
    }

	public List selectGoodsClList(HashMap map) throws Exception {
		return list("gnrl.goods.selectGoodsClList", map);
	}

	public List selectGoodsSchdulList(HashMap map) throws Exception {
		return list("gnrl.goods.selectGoodsSchdulList", map);
	}

	public List selectGoodsNmprList(HashMap map) throws Exception {
		return list("gnrl.goods.selectGoodsNmprList", map);
	}
	
	public List selectGoodsTimeList(HashMap map) throws Exception {
		return list("gnrl.goods.selectGoodsTimeList", map);
	}	
}
