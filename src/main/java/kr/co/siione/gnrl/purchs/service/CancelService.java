package kr.co.siione.gnrl.purchs.service;

import java.util.HashMap;
import java.util.List;

public interface CancelService {
	public int getCancelListCount(HashMap map) throws Exception;
	public List<HashMap> getCancelList(HashMap map) throws Exception;
	public List<HashMap> getPurchsCartList(HashMap map) throws Exception;
}
