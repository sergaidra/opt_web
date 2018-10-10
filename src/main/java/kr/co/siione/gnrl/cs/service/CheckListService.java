package kr.co.siione.gnrl.cs.service;

import java.util.HashMap;
import java.util.List;

public interface CheckListService {
	
	public List<HashMap> getChecklist(HashMap map) throws Exception;
	public void saveChecklist(HashMap map) throws Exception;
}
