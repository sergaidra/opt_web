package kr.co.siione.gnrl.goods.service;

import java.util.HashMap;
import java.util.List;

public interface GoodsService {
    public String getTourClStayng(HashMap map) throws Exception;
    public List<HashMap> getTourClMain(HashMap map) throws Exception;
    public List<HashMap> getTourClList(HashMap map) throws Exception;
    public HashMap getTourClDetail(HashMap map) throws Exception;
    public List<HashMap> getGoodsList(HashMap map) throws Exception;
    public HashMap getGoodsDetail(HashMap map) throws Exception;
    public List<HashMap> getGoodsClList(HashMap map) throws Exception;
    public List<HashMap> getGoodsSchdulList(HashMap map) throws Exception;
    public List<HashMap> getGoodsNmprList(HashMap map) throws Exception;
    public List<HashMap> getGoodsTimeList(HashMap map) throws Exception;
}
