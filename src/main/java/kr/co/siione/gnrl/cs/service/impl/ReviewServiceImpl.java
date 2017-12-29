package kr.co.siione.gnrl.cs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.siione.gnrl.bbs.service.BbsService;
import kr.co.siione.gnrl.cart.service.CartService;
import kr.co.siione.gnrl.cs.service.LiveViewService;
import kr.co.siione.gnrl.cs.service.ReviewService;
import kr.co.siione.gnrl.purchs.service.impl.PointDAO;

@Service("ReviewService")
public class ReviewServiceImpl implements ReviewService {

	@Resource(name = "reviewDAO")
	private ReviewDAO reviewDAO;

	@Resource(name = "pointDAO")
	private PointDAO pointDAO;

	public int getReviewListCount(HashMap map) throws Exception {
		return reviewDAO.getReviewListCount(map);
	}
	
	public List<HashMap> getReviewList(HashMap map) throws Exception {
		return reviewDAO.getReviewList(map);
	}
	
    public void insertPurchsReview(HashMap map) throws Exception {
		HashMap review = reviewDAO.selectPurchsReview(map);
		HashMap point = reviewDAO.selectPurchsPoint(map);
		if(review == null)
			reviewDAO.insertPurchsReview(map);
		else
			reviewDAO.updatePurchsReview(map);
		if("Y".equals(map.get("pointYn")) && point == null) {
			reviewDAO.insertPurchsPoint(map);
			//pointDAO.insertPoint(map);
		}
    }
    
	public HashMap selectPurchsReview(HashMap map) throws Exception {
		return reviewDAO.selectPurchsReview(map);
	}
	
	public void deletePurchsReview(HashMap map) throws Exception {
		reviewDAO.deletePurchsReview(map);
	}

}
