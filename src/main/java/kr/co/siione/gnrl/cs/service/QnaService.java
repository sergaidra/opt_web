package kr.co.siione.gnrl.cs.service;

import java.util.HashMap;
import java.util.List;

public interface QnaService {
	public int getOpinionListCount(HashMap map) throws Exception;	
	public List<HashMap> getOpinionList(HashMap map) throws Exception;	
	public List<HashMap> getOpinionAnswerList(HashMap map) throws Exception;
	public void insertOpinion(HashMap map) throws Exception;	
	public void updateOpinion(HashMap map) throws Exception;
	public HashMap viewOpinion(HashMap map) throws Exception;
	public void deleteOpinion(HashMap map) throws Exception;
}
