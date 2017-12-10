package kr.co.siione.gnrl.cs.service;

import java.util.HashMap;
import java.util.List;

public interface FaqService {
	public void insertBbs(HashMap map) throws Exception;
	public void deleteBbs(HashMap map) throws Exception;
	public void updateBbs(HashMap map) throws Exception;
	public HashMap viewBbs(HashMap map) throws Exception;
	public List<HashMap> selectBbsList(HashMap map) throws Exception;
}
