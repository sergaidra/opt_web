package kr.co.siione.gnrl.cart.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.cart.service.CartService;

@Service("CartService")
public class CartServiceImpl implements CartService {

	@Resource(name = "cartDAO")
	private CartDAO cartDAO;

    public List<HashMap> getCartList(HashMap map) throws Exception {
        return cartDAO.selectCartList(map);
    }

    public HashMap getCartDetail(HashMap map) throws Exception {
        return cartDAO.selectCartDetail(map);
    }

    public List<HashMap> getCartNmprList(HashMap map) throws Exception {
        return cartDAO.selectCartNmprList(map);
    }

    public HashMap getCartValidCnfirm(HashMap map) throws Exception{
        return cartDAO.selectCartValidCnfirm(map);
    }

    public long getCartPayment(HashMap map) throws Exception{
        return cartDAO.selectCartPayment(map);
    }
    
    public void addCart(HashMap map) throws Exception {
        int cart_sn = cartDAO.selectCartSn(map);
        map.put("cart_sn", cart_sn);
    	cartDAO.insertCart(map);

		List<HashMap> nList = (List<HashMap>) map.get("nmpr_list");
		for(HashMap nMap:nList) {
			nMap.putAll(map);
			cartDAO.insertCartNmpr(nMap);
		}
    }

    public void updateCart(HashMap map) throws Exception {
    	cartDAO.updateCart(map);
		cartDAO.deleteCartNmpr(map);

		List<HashMap> nList = (List<HashMap>) map.get("nmpr_list");
		for(HashMap nMap:nList) {
			nMap.putAll(map);
			cartDAO.insertCartNmpr(nMap);
		}    	
    }

    public void deleteCart(HashMap map) throws Exception {
    	cartDAO.deleteCart(map);
    }
}
