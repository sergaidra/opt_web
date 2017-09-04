package kr.co.siione.gnrl.goods.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.goods.service.GoodsService;

@Service("GoodsService")
public class GoodsServiceImpl implements GoodsService {

	@Resource(name = "goodsDAO")
	private GoodsDAO goodsDAO;
	
    public List<HashMap> getUpperTourClMain(HashMap map) throws Exception {
        return goodsDAO.selectUpperTourClMain(map);
    }
    
    public List<HashMap> getTourClList(HashMap map) throws Exception {
        return goodsDAO.selectTourClList(map);
    }

    public HashMap getTourClDetail(HashMap map) throws Exception {
        return goodsDAO.selectTourClDetail(map);
    }

    public List<HashMap> getGoodsList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsList(map);
    }

    public HashMap getGoodsDetail(HashMap map) throws Exception {
        return goodsDAO.selectGoodsDetail(map);
    }

    public List<HashMap> getGoodsClList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsClList(map);
    }

    public List<HashMap> getGoodsSchdulList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsSchdulList(map);
    }

    public List<HashMap> getGoodsNmprList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsNmprList(map);
    }
    
    public List<HashMap> getGoodsTimeList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsTimeList(map);
    }    
}
