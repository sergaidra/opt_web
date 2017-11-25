package kr.co.siione.gnrl.cart.service;

import java.util.HashMap;
import java.util.List;

public interface CartService {
    public List<HashMap> getCartList(HashMap map) throws Exception;
    public List<HashMap> getCartListBySearchSe(HashMap map) throws Exception;
    public HashMap getCartDetail(HashMap map) throws Exception;

    public List<HashMap> getCartNmprList(HashMap map) throws Exception;    
    public HashMap getCartValidCnfirm(HashMap map) throws Exception;
    public HashMap getCartTimeValidCnfirm(HashMap map) throws Exception;
    public HashMap getCartFlightValidCnfirm(HashMap map) throws Exception;
    public List<HashMap> getCartSameValidCnfirm(HashMap map) throws Exception;
    public List<HashMap> getCartDplctValidCnfirm(HashMap map) throws Exception;
    public List<HashMap> getCartStayngValidCnfirm(HashMap map) throws Exception;
    
    public long getCartPayment(HashMap map) throws Exception;
    
    public List<HashMap> getCartListForSchedule(HashMap map) throws Exception;
    
    public void addCart(HashMap map) throws Exception;
    public void updateCart(HashMap map) throws Exception;
    public void deleteCart(List<HashMap> lst) throws Exception;
    
    public List selectCartDetailList(HashMap map) throws Exception;
}
