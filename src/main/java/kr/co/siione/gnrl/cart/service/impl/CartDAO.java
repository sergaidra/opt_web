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
	
	public List selectCartListBySearchSe(HashMap map) throws Exception {
		return list("gnrl.cart.selectCartListBySearchSe", map);
	}
	
    public HashMap selectCartDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartDetail", map);
    }

    public List selectCartNmprList(HashMap map) throws Exception {
		return list("gnrl.cart.selectCartNmprList", map);
    }
    
    public HashMap selectCartValidCnfirm(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartValidCnfirm", map);
    }

    public HashMap selectCartTimeValidCnfirm(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartTimeValidCnfirm", map);
    }
    
    public HashMap selectCartFlightValidCnfirm(HashMap map) throws Exception {
        return (HashMap)selectByPk("gnrl.cart.selectCartFlightValidCnfirm", map);
    }    
    
    public List<HashMap> selectCartSameValidCnfirm(HashMap map) throws Exception {
        return list("gnrl.cart.selectCartSameValidCnfirm", map);
    }
    
    public List<HashMap> selectCartDplctValidCnfirm(HashMap map) throws Exception {
        return list("gnrl.cart.selectCartDplctValidCnfirm", map);
    }
    
    public List<HashMap> selectCartStayngValidCnfirm(HashMap map) throws Exception {
        return list("gnrl.cart.selectCartStayngValidCnfirm", map);
    }    
    
    public long selectCartPayment(HashMap map) throws Exception{
        return (Long)selectByPk("gnrl.cart.selectCartPayment", map);
    }

    public int selectCartSn(HashMap map) throws Exception{
        return (Integer)selectByPk("gnrl.cart.selectCartSn", map);
    }
    
	public List selectCartListForSchedule(HashMap map) throws Exception {
		return list("gnrl.cart.selectCartListForSchedule", map);
	}
	
    public void insertCart(HashMap map) throws Exception {
		insert("gnrl.cart.insertCart", map);
    }

	public void updateCart(HashMap map) throws Exception {
		update("gnrl.cart.updateCart", map);
	}

	public void deleteCart(HashMap map) throws Exception {
		delete("gnrl.cart.deleteCart", map);
	}

    public void insertCartNmpr(HashMap map) throws Exception {
		insert("gnrl.cart.insertCartNmpr", map);
    }

	public void deleteCartNmpr(HashMap map) throws Exception {
		delete("gnrl.cart.deleteCartNmpr", map);
	}
	
	public List selectCartDetailList(HashMap map) throws Exception {
		return list("gnrl.cart.selectCartDetailList", map);
	}
	
    public void updCartPurchsAmountNoHotdeal(HashMap map) throws Exception {
    	update("gnrl.cart.updCartPurchsAmountNoHotdeal", map);
    }
	
}
