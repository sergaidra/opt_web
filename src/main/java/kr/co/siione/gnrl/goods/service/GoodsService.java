package kr.co.siione.gnrl.goods.service;

import java.util.HashMap;
import java.util.List;

public interface GoodsService {
    public List<HashMap> getGoodsExpsrList1(HashMap map) throws Exception;	
    public List<HashMap> getGoodsExpsrList2(HashMap map) throws Exception;	
    public List<HashMap> getGoodsExpsrList3(HashMap map) throws Exception;	
    public List<HashMap> getGoodsExpsrList4() throws Exception;	
    public List<HashMap> getUpperTourClMain(HashMap map) throws Exception;
    public List<HashMap> getTourClList(HashMap map) throws Exception;
    public HashMap getTourClDetail(HashMap map) throws Exception;
    public int getGoodsListCount(HashMap map) throws Exception;
    public List<HashMap> getGoodsList(HashMap map) throws Exception;
    public HashMap getGoodsDetail(HashMap map) throws Exception;
    public List<HashMap> getGoodsClList(HashMap map) throws Exception;
    public List<HashMap> getGoodsSchdulList(HashMap map) throws Exception;
    public List<HashMap> getGoodsNmprList(HashMap map) throws Exception;
    public List<HashMap> getGoodsNmprBySetupSeList(HashMap map) throws Exception;
    public List<HashMap> getGoodsTimeList(HashMap map) throws Exception;

    public HashMap getReviewScore(HashMap map) throws Exception;
    public int getReviewCount(HashMap map) throws Exception;
    public List<HashMap> getReview(HashMap map) throws Exception;
    
    public List<HashMap> getReservationDt(HashMap map) throws Exception;
}
