package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

public interface WishService {
	public int getWishListCount(HashMap map) throws Exception;
	public List<HashMap> getWishList(HashMap map) throws Exception;
}
