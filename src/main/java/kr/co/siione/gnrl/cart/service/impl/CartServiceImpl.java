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

    public HashMap getCartValidCnfirm(HashMap map) throws Exception{
        return cartDAO.selectCartValidCnfirm(map);
    }

    public void addCart(HashMap map) throws Exception {
    	cartDAO.insertCart(map);
    }
}
