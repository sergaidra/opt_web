package kr.co.siione.gnrl.cart.service;

import java.util.HashMap;
import java.util.List;

public interface CartService {
    public List<HashMap> getCartList(HashMap map) throws Exception;
    public HashMap getCartDetail(HashMap map) throws Exception;

    public List<HashMap> getCartNmprList(HashMap map) throws Exception;    
    public HashMap getCartValidCnfirm(HashMap map) throws Exception;

    public long getCartPayment(HashMap map) throws Exception;
    
    public void addCart(HashMap map) throws Exception;
    public void updateCart(HashMap map) throws Exception;
    public void deleteCart(HashMap map) throws Exception;
}
