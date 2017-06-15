package kr.co.siione.gnrl.goods.service;

import java.util.HashMap;
import java.util.List;

public interface GoodsService {
    public List<HashMap> getTourClList(HashMap hashmap) throws Exception;
    public HashMap getTourClDetail(HashMap hashmap) throws Exception;
    public List<HashMap> getGoodsList(HashMap hashmap) throws Exception;
    public HashMap getGoodsDetail(HashMap hashmap) throws Exception;
    public List<HashMap> getGoodsClList(HashMap hashmap) throws Exception;
    public List<HashMap> getGoodsSchdulList(HashMap hashmap) throws Exception;
    public List<HashMap> getGoodsNmprList(HashMap hashmap) throws Exception;
}
