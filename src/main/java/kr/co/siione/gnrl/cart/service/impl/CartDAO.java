package kr.co.siione.gnrl.cart.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class CartDAO extends EgovComAbstractDAO {

	public List selectCartList(HashMap map) throws Exception {
		return list("gnrl.cart.selectCartList", map);
	}

    public HashMap selectCartDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartDetail", map);
    }

    public HashMap selectCartValidCnfirm(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartValidCnfirm", map);
    }
	
    public void insertCart(HashMap map) throws Exception {
		insert("gnrl.cart.insertCart", map);
    }
}
