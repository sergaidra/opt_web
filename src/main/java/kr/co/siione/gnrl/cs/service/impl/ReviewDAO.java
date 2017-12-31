package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;
import kr.co.siione.utl.egov.EgovComAbstractDAO;

@Repository
public class ReviewDAO extends EgovComAbstractDAO {

	public int getReviewListCount(HashMap map) throws Exception {
		return (Integer)selectByPk("gnrl.review.getReviewListCount", map);
	}

	public List<HashMap> getReviewList(HashMap map) throws Exception {
		return list("gnrl.review.getReviewList", map);
	}

    public void insertPurchsReview(HashMap map) throws Exception {
		insert("gnrl.review.insertPurchsReview", map);
    }

    public void updatePurchsReview(HashMap map) throws Exception {
		insert("gnrl.review.updatePurchsReview", map);
    }

	public HashMap selectPurchsReview(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.review.selectPurchsReview", map);
	}

	public void deletePurchsReview(HashMap map) throws Exception {
		insert("gnrl.review.deletePurchsReview", map);
    }

    public void insertPurchsPoint(HashMap map) throws Exception {
		insert("gnrl.review.insertPurchsPoint", map);
    }

	public HashMap selectPurchsPoint(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.review.selectPurchsPoint", map);
	}

	public HashMap getCartPurchsAmount(HashMap map) throws Exception {
		return (HashMap)selectByPk("gnrl.review.getCartPurchsAmount", map);
	}
	
}
