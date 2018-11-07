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

    public List<HashMap> getGoodsExpsrList1(HashMap map) throws Exception {
        return goodsDAO.selectGoodsExpsrList1(map);
    }

    public List<HashMap> getGoodsExpsrList2(HashMap map) throws Exception {
        return goodsDAO.selectGoodsExpsrList2(map);
    }

    public List<HashMap> getGoodsExpsrList3(HashMap map) throws Exception {
        return goodsDAO.selectGoodsExpsrList3(map);
    }

    public List<HashMap> getGoodsExpsrList4() throws Exception {
        return goodsDAO.selectGoodsExpsrList4();
    }

    public List<HashMap> getUpperTourClMain(HashMap map) throws Exception {
        return goodsDAO.selectUpperTourClMain(map);
    }

    public List<HashMap> getUpperTourClList(HashMap map) throws Exception {
        return goodsDAO.selectUpperTourClList(map);
    }

    public List<HashMap> getTourClList(HashMap map) throws Exception {
        return goodsDAO.selectTourClList(map);
    }

    public HashMap getTourClDetail(HashMap map) throws Exception {
        return goodsDAO.selectTourClDetail(map);
    }

    public int getGoodsListCount(HashMap map) throws Exception {
        return goodsDAO.selectGoodsListCount(map);
    }
    
    public List<HashMap> getGoodsList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsList(map);
    }

    public HashMap getGoodsDetail(HashMap map) throws Exception {
        return goodsDAO.selectGoodsDetail(map);
    }
    
    public HashMap selectGoodsEngDetail(HashMap map) throws Exception {
    	return goodsDAO.selectGoodsEngDetail(map);
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
    
    public List<HashMap> getGoodsNmprBySetupSeList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsNmprBySetupSeList(map);
    }
    
    public List<HashMap> getGoodsTimeList(HashMap map) throws Exception {
        return goodsDAO.selectGoodsTimeList(map);
    }    
    
    public HashMap getReviewScore(HashMap map) throws Exception {
        return goodsDAO.getReviewScore(map);
    }    
    
    public int getReviewCount(HashMap map) throws Exception {
        return goodsDAO.getReviewCount(map);
    }
    
    public List<HashMap> getReview(HashMap map) throws Exception {
        return goodsDAO.getReview(map);
    }
    
    public List<HashMap> getReservationDt(HashMap map) throws Exception {
    	return goodsDAO.getReservationDt(map);
    }
}
