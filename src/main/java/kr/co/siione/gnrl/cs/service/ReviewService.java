package kr.co.siione.gnrl.cs.service;

import java.util.HashMap;
import java.util.List;

public interface ReviewService {
	
	public int getReviewListCount(HashMap map) throws Exception;
	public List<HashMap> getReviewList(HashMap map) throws Exception;
	public void insertPurchsReview(HashMap map) throws Exception;
	public HashMap selectPurchsReview(HashMap map) throws Exception;
}
